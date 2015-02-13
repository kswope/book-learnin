require 'pp'
require 'ap'


p "my string"[3, 100] #=> "string" (second arg is length, not position)
p "my string"[3..-1] #=> "string" use a range if you have two positions

p "my string"['string'] #=> 'string' # finds and returns a substring
p "my string"['no string'] #=> nil

target = /str/
if 'my string'[target]
  puts "found target #{target}" #+> found target (?-mix:str)
end
