#!/usr/bin/env ruby


require 'pp'


def my_method 
  yield
end

var = my_method do 
  break :there
  :here
end

p var #=> :there

