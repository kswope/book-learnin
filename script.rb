require 'pp'
require 'ap'





class MyClass

  attr_accessor :data

  def initialize(data)
    self.data = data
  end

  def to_enum
    Enumerator.new do |y|
      self.data.each do |x|
        y << x
      end
    end
  end

  def each(&block)
    return enum_for(:each) unless block_given?
    puts "block_given"
    for x in self.data
      block.call(x)
    end
  end

end


o = MyClass.new([1,2,3,4,5])

p o.each {}
p o.each

p o.each.map{|x| x+1 }

