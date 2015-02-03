#!/usr/bin/env ruby


require 'pp'


class Pair

  include Comparable
  attr_accessor :data

  def initialize(letter, number)
    @data = [letter, number]
  end

  def <=>(other)
    @data[1] <=> other.data[1]
  end

  def inspect
    "[#{data[0]},#{data[1]}]"
  end

end

a = Pair.new('a', 2)
b = Pair.new('b', 3)
c = Pair.new('c', 1)
[a,b,c].sort #=> [[c,1], [a,2], [b,3]]
a > c #=> true
b > a #=> true
c < b #=> true


