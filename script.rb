#!/usr/bin/env ruby

require 'pp'


def wrap(s, width=78)
  s.gsub(/(.{1,20})(\s+|\Z)/, "\\1\n")
end


puts wrap("This text is not too short to be wrapped.", 20)
