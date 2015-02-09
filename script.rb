#!/usr/bin/env ruby


require 'pp'


class MyClassA #<--- default 'Object'
end

class MyClassB < Object
end

p MyClassA.superclass
p MyClassB.superclass
