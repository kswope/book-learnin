#!/usr/bin/env ruby


require 'pp'

m = 'abcdef'.match(/(cd)/)

p m.captures[0] #=> "cd"
p m[0] #=> "cd"
p m.captures[1] #=> nil
p m[1] #=> "cd"
p m.captures[2] #=> nil
p m[2] #=> nil
