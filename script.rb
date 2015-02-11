require 'pp'


class MyInteger

  def to_int
    puts :to_int
    1
  end

  def to_i
    puts :to_i
    1
  end

  def to_fixnum
    puts :to_fixnum
    1
  end

  def coerce
    puts :coerce
    1
  end

  def what
    self
  end

  def to_s
    puts :there
    super
  end

end

i = MyInteger.new
1 == i
i == 1
# 1 + Integer(i)
