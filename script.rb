#!/usr/bin/env ruby

require 'pp'


module MyModule
  def say
    print " MyModule 1 "
    super
    print " MyModule 2 "
  end
end

class Parent
  def say
    print " Parent "
  end
end

class Child < Parent
  # include MyModule # <-----  include
  prepend MyModule # <-----  prepend
  def say
    print " Child "
    super
    puts
  end
end

# include MyModule
# Child.new.say #=> Child  MyModule  Parent

# prepend MyModule, runs say() in MyModule first
Child.new.say #=> MyModule  Child  Parent


RSpec.describe do

  let(:child){ Child.new }

  it 'works' do

    expect(child).not_to be_truthy

  end


end
