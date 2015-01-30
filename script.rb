#!/usr/bin/env ruby

require 'pp'



class Computer

  def initialize(drive_size, cd, memory)
    @drive_size, @cd, @memory = drive_size, cd, memory
  end

end

class ComputerBuilder

  attr_accessor :drive_size, :cd, :memory

  def build
    Computer.new(self.drive_size, self.cd, self.memory)
  end

end

builder = ComputerBuilder.new
builder.drive_size = 700
builder.cd = false
builder.memory = 1000
computer = builder.build
