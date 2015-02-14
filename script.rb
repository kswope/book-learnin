require 'pp'
# require 'ap'


# Attempt to sort hash by values

h = {a:1, b:2, c:3, d:1, e:2}
h = h.sort { |a,b| a[1] <=> b[1] }
p Hash[*h.flatten] #=> {:a=>1, :d=>1, :b=>2, :e=>2, :c=>3} 


hash = {a:1, b:2, c:3, d:1, e:2}
hash = hash.sort_by { |_k,v| v }.to_h
p hash #=>
