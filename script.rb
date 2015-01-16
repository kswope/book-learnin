#!/usr/bin/env ruby

require 'pp'


if m = 'ERROR: bad stuff'.match(/^ERROR:\s+(.+)$/)
  p m[1]
end
