#!/usr/bin/env ruby

require 'pp'




s = "order. wrong the in are words These"
t = s.split(/\s+/).reverse!.join('')   # => "These words are in the wrong order."

puts t

using remember () in regex in split()
'one two three four five'.split(/\s+/) #=> ["one", "two", "three", "four", "five"]
'one two three four five'.split(/(\s+)/) #=> ["one", " ", "two", " ", "three", " ", "four", " ", "five"]
