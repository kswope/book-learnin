#!/usr/bin/env ruby


require 'pp'


val = catch(:outer) do
  catch(:inner) do
    5.times do |x|
      throw(:outer, x) if x==3
    end
  end
end

p val #=> 3
