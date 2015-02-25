require 'pp'
require 'ap'




class MyClass
  attr_accessor :var
  def initialize(data)
    self.var = data
  end
end

MyClass.class_eval do
  def upcase
    var.upcase
  end
end

o = MyClass.new(:hello)

p o.upcase #=> :HELLO
