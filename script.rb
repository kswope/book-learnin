require 'pp'
require 'ap'



C = Class.new

var = :hello

C.class_eval do

  define_method(:return_var) do
    var
  end

end

p C.new.return_var #=> :hello
