#!/usr/bin/env ruby


require 'pp'


class MyClass

  def my_meth
    :hello
  end

  def My_Meth
    :goodbye
  end

end

p MyClass.new.my_meth  #=> :hello
p MyClass.new::my_meth #=> :hello
p MyClass::MyConst #=> 1
p MyClass.new.My_Meth #=> :goodbye
p MyClass.new::My_Meth #=> :goodbye
