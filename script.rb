#!/usr/bin/env ruby

require 'pp'

class MyClass

  @var = :here_in_open

  # class << self
  #   attr_reader :var
  # end

  def self.var
    @var
  end

  def self.instance
    @var = :here_in_instance
  end

  def output
    puts self.class.var
  end

end


MyClass.instance
myobj = MyClass.new
myobj.output

