#!/usr/bin/env ruby


require 'pp'


class MyClass

  def val=(v)
    @v = v
    44
  end

end




o = MyClass.new
p o.val = 1 #=> 1 (not 44)
