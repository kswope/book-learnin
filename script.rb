require 'pp'


class MyInt

  attr_accessor :int

  def initialize(int)
    self.int = int
  end

end


one = MyInt.new 1
two = MyInt.new 1

p one == two #=> false

# reopen class
class MyInt

  include Comparable

  def <=>(other)
    self.int <=> other.int
  end

end

one = MyInt.new 1
two = MyInt.new 1

p one == two #=> true
