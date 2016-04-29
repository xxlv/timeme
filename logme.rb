#!/usr/bin/ruby
require 'mail'


def logme(event)

    body=[]
    body << header
    event.each do |e|
        body << e[:body]
    end
    body << footer

    send_mail body.join('')
end

def header
     "<h3 style='text-align:center'>#{Time.now.year}-#{Time.now.month}-#{Time.now.day} report</h3>
     <div style='color:green'>Hi ,<b>#{ENV['USER']}</b></div>
     "
end

def footer
    "<div style='margin-top:40px;color:gray;float:right;font-size:12px'>Auto generate By Timeme! </div>"
end

def send_mail(content)

    smtp = {
        :address => ENV['MAIL_SERVER_STMP'],
        :port => ENV['MAIL_SERVER_PORT'],
        :domain => ENV['MAIL_SERVER_DOMAIN'],
        :user_name => ENV['MAIL_SERVER_MAIL'],
        :password => ENV['MAIL_SERVER_MAIL_PASS'],
        :enable_starttls_auto => true,
        :openssl_verify_mode => 'none'
    }

    Mail.defaults { delivery_method :smtp, smtp }

    mail = Mail.new do
        from ENV["MAIL_SERVER_MAIL"]
        to  ENV["MAIL_OFFICE_MAIL"]
        subject 'TimeMe Daily Remind!'
        content_type 'text/html; charset=UTF-8'
        body content
    end

    mail.deliver!
end
