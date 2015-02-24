require 'pp'
require 'ap'


# question: does method(&:other_method_name) only work with with
# other_method_names that don't take an argument?


def one
  puts self
end
myproc = Proc.new {|obj| obj.send(:one) }
[1,2,3].map(&myproc) #=> 123




class Symbol
  def to_proc
    puts "In the new Symbol#to_proc!"
    Proc.new {|obj| obj.send(self) }
  end
end

class Fixnum
  def one
    puts self
  end
end



[1,2,3].map(&:one) #=> 123
