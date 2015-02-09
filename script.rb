#!/usr/bin/env ruby


require 'pp'


def plus1(x)
  x += 1
end

meth = self.class.instance_method(:plus1)
p meth #=> #<UnboundMethod: Object#plus1>

meth.bind(Fixnum)

p [1,2,3].map(&:meth) #=> [2,3,4]
