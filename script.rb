#!/usr/bin/env ruby


require 'pp'


class << self

  def my_method
    puts "in my_method"
  end

end

my_method #=> "in my_method"


obj = Object.new

class << obj
  def my_method
    puts 'in obj my_method'
  end
end

obj.my_method # "in obj my_method"


class MyClass
  class << self
    def my_method
      puts "in MyClass my_method"
    end
  end
end


MyClass.my_method #=> "in MyClass my_method"



