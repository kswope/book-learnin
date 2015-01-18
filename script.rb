#!/usr/bin/env ruby

require 'pp'

require('set')

class AnnualWeather

  Reading = Struct.new(:date, :high, :low) do
    def eql? (other) date.eql?(other.date); end
    def hash; date.hash; end # prevents duplication of date
  end

  def initialize () 
    @readings = Set.new
  end

  def add(date, high, low)
    @readings << Reading.new(date, high, low)
  end

end


w = AnnualWeather.new
w.add(2001, 50, 40) #=> added
w.add(2002, 55, 45) #=> added
w.add(2002, 60, 50) # won't add to set because of Reading.hash on date

