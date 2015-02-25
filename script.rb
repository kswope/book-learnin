require 'pp'
require 'ap'




class MyClass

  attr_accessor :var

  def initialize(data)
    self.var = data
  end

end


o = MyClass.new(:hello)


o.instance_eval do
  p self.var
end
