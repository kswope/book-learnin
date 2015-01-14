#!/usr/bin/env ruby

require 'pp'




string = '123abc'

case string
when /^[a..zA..Z]+$/
  "All Letters"
when /^[0-9]+$/
  "All Numbers"
else
  'Mixed'
end #=> 'Mixed'
