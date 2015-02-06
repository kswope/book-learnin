#!/usr/bin/env ruby


require 'pp'



def regular(x: :x, **args)
  p args
end

regular(x: :a, y: :b)
