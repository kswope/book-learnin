#!/usr/bin/env ruby


require 'pp'


class DominantPair

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

class DominantPairCollection

  include Enumerable

  def initialize(pairs)
    @pairs = pairs
  end

  def each
    @pairs.each
  end

end

a = DominantPair.new('a', 2)
b = DominantPair.new('b', 3)
c = DominantPair.new('c', 1)

collection = DominantPairCollection([a,b,c])

p collection

