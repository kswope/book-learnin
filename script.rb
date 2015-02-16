require 'pp'
require 'ap'


class MyClass

  attr_accessor :var

  def initialize(x)
    self.var = x
  end

end

collection = [5,1,3,4,2].map {|x| MyClass.new(x)}
p collection.sort{|a,b| a.var<=>b.var }.map {|c| c.var} #=> [1,2,3,4,5]

