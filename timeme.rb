#!/usr/bin/ruby
$:.unshift('.')

require 'date'
require "curl"

require './task/record_last'
require './task/record_browser'
require './task/record_tomorrow_plan'
require './logme'
require './local_env'

require './kernel/String'



EVENTS=[]


case Time.now.hour
when 22
when 0
end

record_last
record_browser
record_tomorrow_plan

logme EVENTS unless EVENTS.empty?
