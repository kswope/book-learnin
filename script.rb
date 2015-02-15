require 'pp'
require 'ap'




h = Hash.new {|hash,key| hash[key] = 0 }
h.store(:one,1)
p h #=> {:one => 1}

h[:two] #=> 0
p h #=> {:one => 1, :two => 2} 
