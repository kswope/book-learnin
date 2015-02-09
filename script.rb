



module MyStuff
  def puts(*args)
    print "... "
    super
  end
end

class Object
  prepend MyStuff
end

puts :hello
