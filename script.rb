require 'pp'
require 'ap'


class MyClass

  attr_accessor :data

  def initialize(data)
    self.data = data
  end

  def to_enum(method)
    Enumerator.new do |y|
      self.send(method) do |x|
        y << x
      end
    end
  end

  def myeach(&b)
    for i in data
      b.call(i)
    end
  end

end


o = MyClass.new(%i{one two three four five})
e = o.to_enum(:myeach)

loop do
  p e.next
end
