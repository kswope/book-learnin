require 'pp'
require 'ap'


class MyClass

  attr_accessor :var

  def initialize(x)
    self.var = x
  end

  def <=>(other)
    self.var <=> other.var
  end

end

collection = [5,1,3,4,2].map {|x| MyClass.new(x)}
collection.sort.map {|c| c.var} #=> [1,2,3,4,5]

