#!/usr/bin/env ruby


require 'pp'


def greeter(name)
  yield name if block_given?
end



p greeter(:fred)
p greeter(:fred) {|name| "hello #{name}"}
