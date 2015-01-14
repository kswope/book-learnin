#!/usr/bin/env ruby

require 'pp'



upcase_hash = ('a'..'e').to_a.inject({}) {|accum, x| accum[x]=x.upcase; accum }

print upcase_hash

str = 'here, there, everywhere'
puts str.gsub(/e/, upcase_hash) #=> "hErE, thErE, EvErywhErE" 

