#!/usr/bin/env ruby


require 'pp'

def mymeth(a:, b:, c:, **splat)
  [a,b,c,splat]
end


p mymeth(x:100,y:101,z:102,a:1,b:2,c:3)
