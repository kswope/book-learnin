require 'pp'
require 'ap'


target = /str/
if 'my string'.match(target)
  puts "found target #{target}" #+> found target (?-mix:str)
end
