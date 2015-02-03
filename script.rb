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

require 'forwardable'
class DominantPairCollection

  include Enumerable

  extend Forwardable
  def_delegators :@pairs, :each

  def initialize(pairs)
    @pairs = pairs
  end

end

a = DominantPair.new('a', 2)
b = DominantPair.new('b', 3)
c = DominantPair.new('c', 1)

collection = DominantPairCollection.new([a,b,c])

collection.each do |pair|
  p pair
end

