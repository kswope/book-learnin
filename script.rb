#!/usr/bin/env ruby

require 'pp'



# module SuperDumbCrypto
#   KEY = "asf"
# end
# 
# class SuperDumbCrypto::Encrypt
#   def initialize (key=KEY)
#   end
# end
# 
# SuperDumbCrypto::Encrypt.new #=> uninitialized constant SuperDumbCrypto::Encrypt::KEY

Fully qualified call to KEY works (no lexical because we closed the module first)
# module SuperDumbCrypto
#   KEY = "asdf"
# end
# 
# class SuperDumbCrypto::Encrypt
#   def initialize (key=SuperDumbCrypto::KEY)
#     puts key
#   end
# end
# 
# SuperDumbCrypto::Encrypt.new #=> 'asdf'

Lexically scoped call to KEY works

module SuperDumbCrypto
  KEY = "asdf"

class SuperDumbCrypto::Encrypt
  def initialize (key=KEY)
    puts key
  end
end

end
SuperDumbCrypto::Encrypt.new  #=> 'asdf'
