#!/usr/bin/env ruby


require 'pp'


def my_meth(&block)
  block.call
end



my_meth { puts :hello }
