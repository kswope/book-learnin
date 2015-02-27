

class MyClass
  def self.const_missing(const)
    const_set(const, :hello)
    "#{self} #{const}"
  end
end

p MyClass::A #=> "MyClass A"
p MyClass::A #=> :hello
