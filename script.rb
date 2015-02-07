#!/usr/bin/env ruby


require 'pp'



def time_proc(&block)
  block.call(&->{ puts :here })
end

time_proc() do |&proc|
  proc.call
end #=> here

