#!/usr/bin/env ruby


require 'pp'



x = catch(:mycatch) do
  throw(:mycatch, :hello)
end

p x #=> hello
