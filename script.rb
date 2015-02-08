#!/usr/bin/env ruby


require 'pp'

Person = Struct.new(:name, :address, :likes)
kevin = Person.new('kevin', 'ma')

p Person
p kevin #=> #<struct Person name="kevin", address="ma", likes=nil>


