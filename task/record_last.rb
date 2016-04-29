#!/usr/bin/ruby
require 'date'

def record_last

    last= `last | grep #{ENV['USER']} `.split("\n")

    today_login_record=[]
    last.each do |session|
        session.gsub!(/(#{ENV['USER']})\s*(\w+)*\s*(\d+\.\d+.\d+.\d+)*(\w+)/,'')
        if Date.parse(session.strip!)==Date.today
            today_login_record << session
            unless /still/!~ session
                # break
            end
        end
    end

    EVENTS << {:event=>"LOGIN_STEP",:time=>Time.now,:status=>0,:body=>get_record_last_body_by(today_login_record)}
    today_login_record
end


def get_record_last_body_by(today_login_record)

    today_login_record.last =~ /(\d+):(\d+)/
    begin_h, begin_m = $1, $2
    today_login_record.first =~ /(\d+):(\d+)/
    end_h, end_m = $1, $2

    "<div>Your first login at <span style=''> #{begin_h}:#{begin_m}</span>,#{get_praise_for_get_up(begin_h)}</div>"
end

def get_praise_for_get_up(begin_h)

    praise =''
    case begin_h.to_i
    when 0,1,2,3,4,5,6,7
        praise=" <span style='background:red;color:white'>hey,you should sleep early! </span>"
    when 23,22,21,20,19,18
        praise="😢"
    else
        praise="😖"
    end
    praise
end
