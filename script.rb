require 'pp'

class MyInt

  def initialize(int)
    @int = int
  end

  def +(other)
    @int + other
  end

end

int = MyInt.new(1)

p int + 1 #=> 2

int += 1
p int     #=> 2
