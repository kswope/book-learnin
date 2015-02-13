require 'pp'
require 'ap'


class Arrayish

  def initialize(a)
    @a = a
  end

  def []=(index, value)
    @a[index] = value
  end

  def to_a
    @a
  end

end

a = Arrayish.new(%i{a b c})
a[3] = :d # because we implemented []=
p a.class #=> Arrayish
real_array = Array(a) # because we implemented to_a
p real_array.class #=> Array


