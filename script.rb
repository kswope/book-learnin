#!/usr/bin/env ruby

require 'pp'




str = 'here, there, everywhere'
puts str.gsub(/e/) {|m| m.upcase! } #=> hErE, thErE, EvErywhErE


