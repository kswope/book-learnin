#!/usr/bin/env ruby


require 'pp'


def my_method(x,y, one: :one, two: :two, three: :three)
  p [x,y,one,two,three]
end

my_method rescue puts $!           #=> wrong number of arguments (0 for 2)
my_method(1) rescue puts $!        #=> wrong number of arguments (1 for 2)
my_method(1,2)                     #=> [1, 2, :one, :two, :three]
my_method(1,2, one: :a)            #=> [1, 2, :a, :two, :three]
my_method(1,2, one: :ONE, two: :b) #=> [1, 2, :a, :b, :three]



