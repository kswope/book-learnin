#!/usr/bin/env ruby

require 'pp'

require('set')

def tricky
  return 'horses'
ensure
  return 'ponies' # <-- kills exceptions
end
