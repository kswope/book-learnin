require 'pp'
require 'ap'



class C
  def self.hello
    p :hello
  end
end

class D < C
end

D.hello #=> :hello

