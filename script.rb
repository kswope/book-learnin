#!/usr/bin/env ruby

require 'pp'



# defaults to blue, nil is transparent
def set_pixel(args)
  pixel = args[:color] || :blue
  return "setting to #{pixel}"
end

pp set_pixel({:color => :red}) #=> "setting to red"
pp set_pixel({}) #=> "setting to blue"
pp set_pixel({:color => false}) #=> "setting to blue"  WRONG, we want false for transparent

# use fetch instead so we can pass nil or false

def set_pixel(args)
  pixel = args.fetch(:color, :blue) # :blue returned if no key :color 
  return "setting to #{pixel}"
end

pp set_pixel({:color => :red}) #=> "setting to red"
pp set_pixel({}) #=> "setting to blue"
pp set_pixel({:color => false}) #=> "setting to false"

