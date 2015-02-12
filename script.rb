require 'pp'



class MyClass

  def initialize(data)
    @data = data
  end

  def to_a
    puts "calling to_a"
    @data.to_a
  end

end


def mymethod(*args)
  p args
end


o = MyClass.new( %w{one two three} )
# mymethod(*o)


a,b,c = *o



puts a,b,c
