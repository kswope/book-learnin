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

appender << 'a'
appender << 'b'
appender << 'c'

p appender.data
