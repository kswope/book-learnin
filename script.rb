require 'pp'


class MyInt
  class << self
    def hello
      puts :hi
    end
  end
end


MyInt.hello

