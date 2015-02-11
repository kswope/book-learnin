require 'pp'



class MyClass
  def +@ # <--- weird but right
    :+
  end

  def -@ # <--- weird but right
    :-
  end
end

a = MyClass.new
p +a

b = MyClass.new
p -b
