require 'pp'
require 'ap'



e = Enumerator.new do |y|
  loop do
    y << Time.now
  end
end

p e.first(3) #=> [2015-02-19 18:51:13 -0500, 2015-02-19 18:51:13 -0500, 2015-02-19 18:51:13 -0500]
 


