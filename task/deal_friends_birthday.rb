#!/usr/bin/ruby

ENV['honery_birthday']=Time.new(Time.now.strftime("%Y").to_i,9,20).to_i.to_s;

def send_message(message,phone)
    puts "send to #{phone} with message #{message} at time #{Time.now}"
end

def get_birthday_by_phone(phone)
    Time.now.to_i.to_s
end

def get_my_friends
    {
        :nickname=>'PHONE_NUMBER'
    }
end

my_friends=get_my_friends


#generate a random message for my friends's birthday
random_happy_message=[
    "好久不见，马上就是你生日，生日快乐！"
    "生日快乐!",
    "What a nice day ,happy to you my best friend,happy birthday!",
    "Hello,long time no see, happy birthday to you!",
].sample



#check birthday and send a message
my_friends.each do |nickname,phone|
    birthday=get_birthday_by_phone phone
    send_message random_happy_message,phone if birthday.to_i - Time.now.to_i <= 1*24*60*60
end
