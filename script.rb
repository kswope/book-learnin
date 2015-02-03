#!/usr/bin/env ruby


require 'pp'

class VowelFinder
  include Enumerable

  def initialize(string)
    @string = string
  end

  def each
    @string.scan(/[aeiou]/) do |vowel|
      yield vowel
    end
  end
end

vf = VowelFinder.new('the quick brown fox jumped over the lazy dog')
p vf.inject(:+)
p vf.each(&:upcase)
p vf.map(&:upcase)
