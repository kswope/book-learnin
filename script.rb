



module MyModule
  def hello
    p :hello
  end
end

o1 = Object.new
o1.extend(MyModule) # extend includes a module into the eigenclass
o1.hello #=> :hello

o2 = Object.new
class << o2 # enter eigenclass
  include MyModule
end

o2.hello #=> :hello
