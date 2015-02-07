#!/usr/bin/env ruby


require 'pp'


p [1,2,3].inject(&:+) #=> 6
p [1,2,3].inject(:+)  #=> 6

