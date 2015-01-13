#!/usr/bin/env ruby

require 'pp'


String#slice and [] work the same

puts "abcd".slice(/../) # => 'ab'
puts "abcd"[/../] # => 'ab'

