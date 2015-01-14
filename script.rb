#!/usr/bin/env ruby

require 'pp'


puts 'this and that'.slice(/\s.*\s/)

'this and that'[/\s(.*)\s/]
puts $1 #=> 'and'


