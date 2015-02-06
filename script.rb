#!/usr/bin/env ruby


require 'pp'




module MyModule
  # module_function
  def say_hello
    puts :hello
  end
  def say_goodbye
    puts :goodbye
  end
end

include MyModule # The only way to access MyModule.say_hello
# say_hello   #=> hello
# say_goodbye #=> hello

MyModule.say_hello   #=> hello
MyModule.say_goodbye #=> goodbye
