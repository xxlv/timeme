#!/usr/bin/ruby
$:.unshift('.')

require 'date'
require './task/record_last'
require './task/record_browser'
require './task/check_tomorrow_plan'
require './logme'
require './local_env'



EVENTS=[]

case Time.now.hour
when 22
    # record_browser
    # record_last
when 0
end

record_browser
record_last

logme EVENTS unless EVENTS.empty?
