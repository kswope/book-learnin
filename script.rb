require 'pp'


# same as above
var = 1
var &&= 2 # same as next line
# var = var && 2 
p var #=> 2

var = nil
var &&= 2 # same as next line
# var = var && 2
p var #=> nil

