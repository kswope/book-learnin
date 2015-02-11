require 'pp'



class MyClass

  def !
    'calling !'
  end

end

o = MyClass.new
p !o #=> 'calling !'
p (not o) #=> 'calling !' 

