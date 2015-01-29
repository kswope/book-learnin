#!/usr/bin/env ruby

require 'pp'



class MyClass
  def self.hello
    puts :hello
  end
end

def MyClass.goodbye
  puts :goodbye
end


MyClass.hello
MyClass.goodbye
