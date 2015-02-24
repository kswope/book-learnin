require 'pp'
require 'ap'



MyClass = Class.new

# define class method "outside" class
def MyClass.hello
  p :hello
end

# define class method "inside" class
class MyClass
  def self.goodbye
    p :goodbye
  end
end

MyClass.hello
MyClass.goodbye
