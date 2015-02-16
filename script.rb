require 'pp'
require 'ap'



p ('a'..'c').cover? 'abc' #=> true
p ('a'..'c').include? 'abc' #=> false

p ('a'..'c').cover? 'bcd' #=> true
p ('a'..'c').include? 'bcd' #=> false

p ('a'..'c').cover? 'cde' #=> false
p ('a'..'c').include? 'cde' #=> false


p [1,2,3].include? 1 #=> true
p [1,2,3].include? 2 #=> true
p [1,2,3].include? 3 #=> true
p [1,2,3].include? 4 #=> false
