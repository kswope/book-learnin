#!/usr/bin/env ruby


require 'pp'


class BetterVar

  @var = 99

  class << self
    attr_accessor :var
  end

  def var
    self.class.var
  end

  def var=(x)
    self.class.var = x
  end

end

p BetterVar.var #=> 99
bv = BetterVar.new
bv.var=200
p BetterVar.new.var #=> 200
p BetterVar.var #=> 200



