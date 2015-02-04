#!/usr/bin/env ruby


require 'pp'


class Appender

  attr_accessor :data

  def initialize
    @data = ''
  end

  def <<(x)
    @data += x
  end

end


appender = Appender.new

appender << 'a' << 'b' << 'c'

p appender.data #=> 'abc'
