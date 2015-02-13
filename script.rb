require 'pp'

require 'ap'

class MyInt
  class << self
    def class_hello
      ap :hi
    end
  end

  def instance_hello
    ap :hi
  end


end



ap MyInt.instance.methods
