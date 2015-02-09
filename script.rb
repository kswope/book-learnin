#!/usr/bin/env ruby


require 'pp'


class Conversation

  def start(&b)
    instance_eval(&b) #<-- sauce
  end

  def hello
    puts :hello
  end

  def goodbye
    puts :goodbye
  end

end

Conversation.new.start do
  hello   #=> hello
  goodbye #=> goodbye
end 
