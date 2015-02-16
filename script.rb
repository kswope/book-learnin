require 'pp'
require 'ap'


e = [1,2,3,4,5,6]

p e.inject([]){|acc, x| acc << x; acc} 
p e.reduce([]){|acc, x| acc << x; acc} 
