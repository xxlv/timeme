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
     <div style='color:green'>Hi ,<b>#{ENV['USER']}</b>, I'm Xiaobai,Nice day</div>
     "
end

def footer
    "<div style='margin-top:40px;color:gray;float:right;font-size:12px'>Auto generate By Timeme! </div>"
end

def send_mail(content)
    smtp = {
        :address => 'smtp.qq.com',
        :port => 25, :domain => 'qq.com',
        :user_name => ENV["SERVER_MAIL"],
        :password => ENV["SERVER_MAIL_PASS"],
        :enable_starttls_auto => true,
        :openssl_verify_mode => 'none'
    }
    
    Mail.defaults { delivery_method :smtp, smtp }
    mail = Mail.new do
      from ENV["SERVER_MAIL"]
      to  ENV["OFFICE_MAIL"]
      subject 'TimeMe Daily Remind!'
      content_type 'text/html; charset=UTF-8'
      body content
    end
    mail.deliver!
end
