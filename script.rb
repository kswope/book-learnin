#!/usr/bin/env ruby

require 'pp'


puts 'this and that'.slice(/\s.*\s/)
puts 'this and that'[/\s(.*)\s/]
puts $1


