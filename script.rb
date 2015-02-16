require 'pp'
require 'ap'


class MyClass

  def initialize(x)
    @var = x
  end

  def <=>(other)
    self <=> other
  end

end
