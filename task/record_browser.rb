#!/usr/bin/ruby

require './lib/chrome_spy'

SHOW_HISTORY_SIZE=10

def record_browser

    # puts Time.at((13105540909739129/1000000-11644473600))
    # history_db="/Users/#{ENV['USER']}/Library/Application Support/Google/Chrome/Default/History"
    # show_history_size=SHOW_HISTORY_SIZE
    # begin
    #     today_time=Date.today.to_time.to_i*1000000+11644473600
    #     db = SQLite3::Database.new history_db
    #     urls=[]
    #     puts "select url,title,last_visit_time,visit_count from urls where last_visit_time > #{today_time} ORDER BY visit_count DESC,last_visit_time DESC LIMIT #{show_history_size}"
    #     db.execute("select url,title,last_visit_time,visit_count from urls where last_visit_time > #{today_time} ORDER BY last_visit_time DESC ,visit_count DESC  LIMIT #{show_history_size}") do |row|
    #         urls << row
    #     end
    # rescue
    #     EVENTS << {:event=>"BORWSER_LOCK",:time=>Time.now,:status=>0}
    # end
    today_urls={}
    urls=ChromeSpy.most_frequent_sites(SHOW_HISTORY_SIZE,"last_visit_time >#{ChromeSpy.to_chrome(Date.today.to_time)} ")
    keywords=ChromeSpy.recent_searches

    urls.each do |url|
        if (url.url =~ /(\w+\.\w+)/) && today_urls.has_key?($1)
            unless url.title.empty?
                today_urls[$1].title= today_urls[$1].title.to_s+url.title.to_s+"<hr/>"
            end
            today_urls[$1].visit_count =today_urls[$1].visit_count.to_i+url.visit_count.to_i
            today_urls[$1].today_visit_count += 1
        else
            today_urls[$1] = url
            today_urls[$1].today_visit_count = 1

        end
    end

    EVENTS << {:event=>"BORWSER_HISTORY",:time=>Time.now,:status=>0,:body=>get_record_browser_by(today_urls)}
    EVENTS << {:event=>"BORWSER_HISTORY",:time=>Time.now,:status=>0,:body=>get_record_browser_recent_searches(keywords)}

    nil
end

def get_record_browser_by (urls)

    body="<hr/> <div style='color:blue;'>[The following section is your browser history list (total :#{urls.count})] </div>"
    body+='<div><table border=\'1\' cellspacing="0" cellpadding="0">
        <tr style=\'background-color:gray\'>
        <th style=\'width:200px\'>url</th>
        <th style=\'width:200px\'>title</th>
        <th style=\'width:210px\'>last visit time</th>
        <th>visit count</th>
        <th>today visit count</th>
    </tr>'
    urls.each do |url|
        url=url[1]
        if url.url.length <=25
            a_text=url.url
        else
            a_text=url.url[0,25]
        end
        body+="<tr>
        <td><a href='#{url.url}'>#{a_text}</a></td>
        <td>#{url.title}</td>
        <td>#{url.last_visit_time}</td>
        <td>#{url.visit_count}</td>
        <td>#{url.today_visit_count}</td>
        </tr>"
    end
    body+='</table></div>'
    body
end


def get_record_browser_recent_searches (keywords)

    body="<hr/> <div style='color:blue;'>[The following section is your recent searches  (total :#{keywords.count})] </div>"
    body+='<div><table border=\'1\' cellspacing="0" cellpadding="0">'

    keywords.each do |keyword|
        body+="<td>#{keyword.term}</td>"
    end
    body+='</tr></table></div>'
    body
end
