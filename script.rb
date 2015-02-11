require 'pp'

require 'forwardable'
class MyInt

  extend Forwardable
  def_delegators :@int, :to_s, :+

  def initialize(str)
    @int = str
  end

end

int = MyInt.new(1)

p int
p int.to_s #=> "1"
p int + 1 #=> 2
