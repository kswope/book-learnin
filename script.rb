require 'pp'



class MyClass
  def +()
    :+
  end

  def -()
    :-
  end
end

p MyClass.new +
p MyClass.new -
