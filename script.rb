#!/usr/bin/env ruby

require 'pp'

require 'singleton'

class Klass
  include Singleton
  # ...
end

a,b  = Klass.instance, Klass.instance
p a == b #=> true

