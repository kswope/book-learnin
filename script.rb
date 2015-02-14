require 'pp'
require 'ap'


a = %i{ one two three}

p a.pop(2) #=> [:two, :three]
p a        #=> :one

