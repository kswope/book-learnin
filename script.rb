#!/usr/bin/env ruby

require 'pp'

require('set')


class MyError < StandardError

  def initialize(str)
    super("str: #{str}")
  end

end


raise MyError.new('passed in string')
