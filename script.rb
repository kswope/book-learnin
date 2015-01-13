#!/usr/bin/env ruby

require 'pp'


def asdf1
  <<-EOS
  Line one
  Line two
  Line three
  EOS
end

def asdf2
  %Q{
  Line one
  Line two
  Line three
  }[/^\s(.*)/]
end

puts babf1
puts bsapf2

var foo = "method(" + argument1 + "," + argument2 + ")";

