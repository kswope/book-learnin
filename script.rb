#!/usr/bin/env ruby


require 'pp'


module MyModule

  MyConst = :here

  def mymeth
    p 'in mymeth'
  end

end


p MyModule::MyConst

# include MyModule
# mymeth
p MyConst
