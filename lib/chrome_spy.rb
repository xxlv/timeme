#!/usr/bin/env ruby

# From http://www.intridea.com/blog/2011/2/2/fun-with-ruby-mining-your-chrome-history
# sets up access to Google Chrome history sqlite file
require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'logger'

db = File.expand_path("~/Library/Application Support/Google/Chrome/Default/History")
newdb = "/tmp/chrome.sqlite"
`cp "#{db}" "#{newdb}"`

ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => newdb
})
#ActiveRecord::Base.logger = Logger.new(STDOUT)
# If you'd like to see the entire schema...
# puts ActiveRecord::SchemaDumper.dump

module TimestampAccessors
  def timestamp_accessors(*attributes)
    attributes.each do |attr|
      name = attr.to_s

      # Some timestamps have 17 digits
      # Since 10000000000 is year 2286, so I'm assuming that no dates are longer
      # than 10 digits
      define_method(name) {
        raw = read_attribute(name).to_s
        epoch = (raw.to_i / 1000000) -11644473600
        Time.at(epoch)
      }

      define_method(name+'=') { |t|
        write_attribute(name, t.to_i)
      }
    end
  end
end
ActiveRecord::Base.extend(TimestampAccessors)

class Download < ActiveRecord::Base
  # t.string  "full_path",      :limit => nil, :null => false
  # t.string  "url",            :limit => nil, :null => false
  # t.integer "start_time",                    :null => false
  # t.integer "received_bytes",                :null => false
  # t.integer "total_bytes",                   :null => false
  # t.integer "state",                         :null => false

  timestamp_accessors :start_time
end

# # join model
class KeywordSearchTerm < ActiveRecord::Base
  # t.integer "keyword_id",                :null => false
  # t.integer "url_id",                    :null => false
  # t.string  "lower_term", :limit => nil, :null => false
  # t.string  "term",       :limit => nil, :null => false
  self.primary_key = :keyword_id
  belongs_to :url
end

class Meta < ActiveRecord::Base
  # t.string "value", :limit => nil
end

class Segment < ActiveRecord::Base
  belongs_to :url
  has_many :segment_usages
end

class SegmentUsage < ActiveRecord::Base
  # t.integer "segment_id",                 :null => false
  # t.integer "time_slot",                  :null => false
  # t.integer "visit_count", :default => 0, :null => false
  self.table_name = "segment_usage"
  belongs_to :segment
  timestamp_accessors :time_slot
end

class Url < ActiveRecord::Base
  # t.string  "url",             :limit => nil
  # t.string  "title",           :limit => nil
  # t.integer "visit_count",                    :default => 0, :null => false  # seems out of sync
  # t.integer "typed_count",                    :default => 0, :null => false
  # t.integer "last_visit_time",                               :null => false
  # t.integer "hidden",                         :default => 0, :null => false
  # t.integer "favicon_id",                     :default => 0, :null => false
  attr_accessor :today_visit_count
  timestamp_accessors :last_visit_time
  has_many :visits, :foreign_key => "url"
end

# class VisitSource < ActiveRecord::Base
#   self.table_name = "visit_source"
#   # t.integer "source", :null => false
# end

class Visit < ActiveRecord::Base
  # t.integer "url",                       :null => false
  # t.integer "visit_time",                :null => false
  # t.integer "from_visit" ???
  # t.integer "transition", :default => 0, :null => false
  # t.integer "segment_id"
  # t.boolean "is_indexed"

  timestamp_accessors :visit_time
  belongs_to :url, :foreign_key => 'url'
  belongs_to :segment
end

class ChromeSpy
  class <<self

    def to_chrome(time)
      return ((time.to_i * 10000000 )+116444736000000000)/10
    end

    def recent_searches
      KeywordSearchTerm.includes('url').order('urls.last_visit_time desc')
    end

    def most_frequent_sites(limit,where='1=1')
        Url.order('last_visit_time desc').order('visit_count desc').where(where).limit(limit).all
    end

    def most_frequently_typed_addresses(limit,where='1=1')
        Url.order('typed_count desc').where(where).limit(limit).all
    end

    def recent_downloads(limit,where='1=1')
        Download.order('start_time DESC').where(where).limit(limit).all
    end
  end
end
