require 'pp'
require 'ap'


# using extend to modify a single object in a convenient way


module HashWithLogging

  def []=(key, value)
    puts "Assigning #{value} to #{key}"
    super
  end

end

hash = {}
hash.extend(HashWithLogging)
hash[:one] = 1 #=> Assigning 1 to :one

