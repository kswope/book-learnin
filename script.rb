#!/usr/bin/env ruby

require 'pp'



# using a hash with empty array default values

hash = Hash.new { |hash, key| hash[key] = [] }
hash[:a] << 1
hash[:b] << 2
hash[:b] << 3

pp hash #=> {:a=>[1], :b=>[2, 3]}

hash.each do |k,v|
  puts k,v
end
