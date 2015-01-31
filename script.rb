#!/usr/bin/env ruby

require 'pp'

# One = Class.new # implicit
class One
 
 def _superclass
  superclass
 end 


end

class Two < One
end



pp One.class # => Class
pp One.superclass # => Class
pp One.new.class # => One
pp Two.superclass # => Object


