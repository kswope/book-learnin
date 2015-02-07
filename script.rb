#!/usr/bin/env ruby


require 'pp'



val = 1.upto(10).map do |x|
  return :bing if x == 5
  x
end

p val
