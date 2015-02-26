require 'pp'
require 'ap'


# def inside a instance_eval creates a method on the classes eigenclass, aka, class method

C = Class.new
C.instance_eval do
  def hello
    :hello_from_instance
  end
end

p C.hello #=> :hello_from_instance (instance of Class, aka eigenclass)

# remove contstant
Object.send(:remove_const, :C)

# class_eval on a class just reopens the class, but its a way to dynamically define method with define_method(:method)

C = Class.new
C.class_eval do
  def hello
    :hello_from_class
  end
end

p C.new.hello #=> :hello_from_class


# NOTE: don't rely on bindings and closures for instnce_eval, it can do weird things
