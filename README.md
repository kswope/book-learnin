# Ruby-Study Random Notes

-----

## [Book] Practical Object-Oriented Design in Ruby

#### Writing Code That Embraces Change:

Always wrap instance variables in accessor methods instead of directly
referring to variables.

Enforce single responsibility everywhere

Methods that have a single responsibilty:

  * Expose previously hidden qualities
  * Avoid the need for comments
  * Encourage reuse
  * Are easy to move to another class
  * (me: easier to understand)
  * (me: easier to test)

> Because you are writing changeable code, you are best served by postponing
decisions until you are absolutely forced to make them. Any decision you make
in advance of an explicit requirement is just a guess. Don’t decide; preserve
your ability to make a decision later.

#### OpenStruct vs Struct
>The difference between the two is that Struct takes position order
initialization arguments while OpenStruct takes a hash for its initialization
and then derives attributes from the hash.

[OpenStruct, Struct blog posting]
(http://blog.steveklabnik.com/posts/2012-09-01-random-ruby-tricks--struct-new)


#### TODO: [Official Docs] (http://www.ruby-doc.org/)

##### Operator I keep forgetting to use

    @wheel ||= Wheel.new(rim, tire)


##### specifying defaults using fetch (page 49)

    def initialize(args)
      @chainring = args.fetch(:chainring, 40) 
      @cog = args.fetch(:cog, 18) 
      @wheel = args[:wheel]
    end


My example


    # defaults to blue, nil is transparent
    def set_pixel(args)
      pixel = args[:color] || :blue
      return "setting to #{pixel}"
    end

    pp set_pixel({:color => :red}) #=> "setting to red"
    pp set_pixel({}) #=> "setting to blue"
    pp set_pixel({:color => false}) #=> "setting to blue"  WRONG, we want false for transparent

    # use fetch instead so we can pass nil or false

    def set_pixel(args)
      pixel = args.fetch(:color, :blue) # :blue returned if no key :color 
      return "setting to #{pixel}"
    end

    pp set_pixel({:color => :red}) #=> "setting to red"
    pp set_pixel({}) #=> "setting to blue"
    pp set_pixel({:color => false}) #=> "setting to false"





##### specifying defaults by merging a defaults hash

	def initialize(args)
	  args = defaults.merge(args) 
	  @chainring = args[:chainring]
	  # ...
	end
	
	def defaults
	  {:chainring => 40, :cog => 18}
	end


#### Law Of Demeter notes:

>Using delegation to hide tight coupling is not the same as decoupling the code.


#### Writing Inheritable Code

##### Recognize the Antipatterns

* An object that uses a variable with a name like type or category to
   determine what message to send to self contains two highly related but
   slightly different types.
* When a sending object checks the class of a receiving object to deter-
   mine what message to send, you have overlooked a duck type.

##### Insist on the Abstraction

All of the code in an abstract superclass should apply to every class that inherits it.

Subclasses that override a method to raise an exception like “does not
implement” are a symptom of this problem.  When subclasses override a method to
declare that they do not do that thing they come perilously close to declaring
that they are not that thing. Nothing good can come of this.


    def default_tire_size
      raise NotImplementedError, "This #{self.class} cannot respond to:"
    end

##### Honor the Contract

Subclasses agree to a contract; they promise to be substitutable for their superclasses.

##### Use the Template Method Pattern

???


##### Preemptively Decouple Classes

Avoid writing code that requires its inheritors to send super; instead use hook
messages to allow subclasses to participate while absolving them of
responsibility for knowing the abstract algorithm.


TODO: [Forwardable]( http://www.ruby-doc.org/stdlib-2.0/libdoc/forwardable/rdoc/Forwardable.html)




## [Book] Ruby Cookbook

A way strings are made that I keep forgetting: %Q and %q and matched chars

    str = %q{This is a string}
    w = 'nother'
    str = %Q|This is a#{w} string|

I also keep forgetting here doc syntax, ('-' lets you indent the end token)

    str = <<-EOS
    Line one
    Line two
    line three
    EOS

Printf style string formatting:

    'this is a %s' % 'string'
    
ERB outside of rails

    require 'erb'

    template = %q{
      Contents:
        <% array.each do |element| -%>
          <%= element %>
        <% end -%>
    }

    template = ERB.new template, nil, '-'

    array = %w{one two three four five}
    puts template.run(binding)


using () in regex in split()

    'one two three four five'.split(/\s+/) #=> ["one", "two", "three", "four", "five"]
    'one two three four five'.split(/(\s+)/) #=> ["one", " ", "two", " ", "three", " ", "four", " ", "five"]


print smiley to terminal

    puts "\xe2\x98\xBA"

ring bell

    puts "\a"


String#each was removed in 1.9 and replaced with String#each_line and String#each_char

String#scan (can also take a code block)

    "one two three four".scan(/\w+/) #=>  ["one", "two", "three", "four"] 

Duck typing note:

>The idea to take to heart here is the general rule of duck typing: to see
whether provided data implements a certain method, use respond_to? instead of
checking the class.This lets a future user (possibly yourself!) create new
classes that offer the same capability, without being tied down to the
preexisting class structure. All you have to do is make the method names match
up.


String#slice and [] work the same

If you pass indexes:

    s = 'My kingdom for a string!'
    puts s.slice(3,7) # => "kingdom"
    puts s[3,7]       # => "kingdom"

If you pass a regex:

    puts "abcd".slice(/../) # => 'ab'
    puts "abcd"[/../] # => 'ab'

Wrapping long lines

    def wrap(s, width=78)
      s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
    end


All ways to make regex

    /something/
    Regexp.new("something")
    Regexp.compile("something")
    %r{something}


(regex) sub and gsub

    re = /this/im
    'this'.sub(re, 'that')
    'this'.sub!(re, 'that')

    'this'.gsub(re, 'that')
    'this'.gsub!(re, 'that')

(regex) perlish match

    'this' =~ re #=> 0
    re =~ 'this' #=> 0

(regex) slice and its other form (works with regex memory too)

    'this and that'.slice(/\s.*\s/) #=> ' and '
    'this and that'[/\s.*\s/] #=> ' and '

    'this and that'[/\s(.*)\s/] # memory
    puts $1 #=> 'and'

(regex) sub/gsub with hash param

    upcase_hash = ('a'..'e').to_a.inject({}) {|accum, x| accum[x]=x.upcase; accum }
    upcase_hash #=> {"a"=>"A", "b"=>"B", "c"=>"C", "d"=>"D", "e"=>"E"}
    str = 'here, there, everywhere'
    puts str.gsub(/e/, upcase_hash) #=> "hErE, thErE, EvErywhErE" 

(regex) sub/gsub with block param

    str = 'here, there, everywhere'
    puts str.gsub(/e/) {|m| m.upcase! } #=> hErE, thErE, EvErywhErE

(regex) case statement

    string = '123abc'

    case string
    when /^[a..zA..Z]+$/
      "All Letters"
    when /^[0-9]+$/
      "All Numbers"
    else
      'Mixed'
    end #=> 'Mixed'


Regexp::union (my really uncreative example)

    victim = 'this is my string'
    re = Regexp.union('this', 'string')
    victim.gsub!(re, '_')
    puts victim #=> "_ is my _"



Array operators

    [1,2,3] << [4,5,6] #=> [1, 2, 3, [4, 5, 6]] 
    [1,2,3] + [4,5,6] #=> [1, 2, 3, 4, 5, 6]

You can split out an array into its components

    array = [:red, :green, :blue]
    c, a, b = array
    a # => :green
    b # => :blue
    c # => :red

You can even use the splat operator to extract items from the front of the array:

    a, b, *c = [12, 14, 178, 89, 90]
    a # => 12
    b # => 14
    c # => [178, 89, 90]

To ensure that duplicate values never get into your list, use a Set instead of
an array. If you try to add a duplicate element to a Set, nothing will happen.

    require 'set'
    survey_results = [1, 2, 7, 1, 1, 5, 2, 5, 1]
    distinct_answers = survey_results.to_set
    # => #<Set: {5, 1, 7, 2}>

Numeric#step

    0.step(10, 2) {|x| print x, ' ' } #=> '0 2 4 6 8 10 '


Using a hash with empty array default values

    hash = Hash.new { |hash, key| hash[key] = [] }
    hash[:a] << 1
    hash[:b] << 2
    hash[:b] << 3
    pp hash #=> {:a=>[1], :b=>[2, 3]}


Reverse lookup for hash

    hash = {one:1, two:2, three:3}
    pp hash.invert[1] #=> :one




## [Book] Rails 4 Test Prescriptions 

Setting up RSpec (for minitesters)

    group :development, :test do 
      gem 'rspec-rails', '~> 3.1'
    end

    $ rails generate rspec:install


The actual spec is defined with it(), which takes an optional string argument
that documents the spec, and then a block that is the body of the spec. The
string argument is not used internally to identify the spec—you can have
multiple specs with the same description string.

For single-line tests in which a string description is unnecessary, we use
specify to make the single line read more clearly, such as this:

    specify { expect(user.name).to eq("fred") }

Why not just use it('') instead of specify() ???

expect() takes any object as an argument and returns ExpectationTarget

ExpectationTarget olds on to the object and itself responds to two messages,
to() and not_to()

Both to() and not_to() expect as an argument a RSpec matcher.

RSpec matcher responds to a matches?() method.

Look at some objects

    RSpec.describe "Something" do
        puts expect(true) #=> RSpec::Expectations::ExpectationTarget
        puts eq(3) #=> RSpec::Matchers::BuiltIn::Eq
        puts be_truthy #=> RSpec::Matchers::BuiltIn::BeTruthy
        puts expect(3).to eq(3) #=> true
        puts expect(3).to be_truthy #=> true
    end

be() is weird

    RSpec.describe "Something" do
      puts be #=> RSpec::Matchers::BuiltIn::Be
      puts be(3) #=> RSpec::Matchers::BuiltIn::Equal
    end


## [Book] Effective Ruby


### Item 1: Understand What Ruby Considers to Be True

EVERY value is true except false and nil.

If you need to differentiate between false and nil, either use the nil? method
or use the “==” operator with false as the left operand.  If you use x on the
left then there's a possiblity that x.== was messed with and you won't get what
you expect.

    if false == x
      something
    end

### Item 2: Treat All Objects as If They Could Be nil

There’s a surprisingly large number of ways nil can unexpectedly get introduced
into your running program. The best defense is to assume that any object might
actually be the nil object. This includes arguments passed to methods and
return values from them.

When appropriate, use conversion methods such as to_s and to_i to coerce nil
objects into the expected type.  Make methods like the following more robust by
using to_s instead of resorting to throwing "undefined method" exception

    def fix_title (title)
      title.to_s.capitalize
    end

    def add_ten(x)
      x.to_i + 10
    end


use compact() to remove nils from arrays

    name = [first, middle, last].compact.join(" ")


### Item 3: Avoid Ruby’s Cryptic Perlisms


Avoid using ~= and $1, $2, use match() instead

    if m = 'ERROR: bad stuff'.match(/^ERROR:\s+(.+)$/)
      m[1] # 'bad stuff'
    end

Note: match() also works in reverse (its both a method of string and Regexp)

    /find (me)/.match('find me')[1]  #=> 'me'
    'find me'.match(/find (me)/)[1]  #=> 'me'


use $LOAD_PATH instead of $:

For other cryptic perlism 

    require('English')

Look them up

    $ ri English

Avoid methods that implicitly read from, or write to, the $_ global variable (I
didn't even know it existed outside perl, so no problem)


### Item 4: Be Aware That Constants Are Mutable

* Always freeze constants to prevent them from being mutated.

* If a constant references a collection object such as an array or hash,
freeze the collection and its elements.

* To prevent assignment of new values to existing constants, freeze the module
they’re defined in.

### Item 5: Pay Attention to Run-Time Warnings

* Use the “-w” command-line option to the Ruby interpreter to enable
compile-time and run-time warnings. You can also set the RUBYOPT environment
variable to “-w”.

* If you must disable run-time warnings, do so by temporarily setting the
$VERBOSE global variable to nil.


### Item 6: Know How Ruby Builds Inheritance Hierarchies

* To find a method, Ruby only has to search up the class hierarchy. If it
  doesn’t find the method it’s looking for it starts the search again, trying
to find the method_missing method.

* Including modules silently creates singleton classes that are inserted into
  the hierarchy above the including class.

* Singleton methods (class methods and per-object methods) are stored in
  singleton classes that are also inserted into the hierarchy.

### Item 7: Be Aware of the Different Behaviors of super

* When you override a method from the inheritance hierarchy the super keyword
  can be used to call the overridden method.

* Using super with no arguments and no parentheses is equivalent to passing it
  all of the arguments that were given to the enclosing method.

* If you want to use super without passing the overridden method any arguments,
  you must use empty parentheses, i.e., super().

* Defining a method_missing method will discard helpful information when a
  super call fails. See Item 30 for alternatives to method_ missing.

### Item 8: Invoke super When Initializing Subclasses

* Ruby doesn’t automatically call the initialize method in a super- class when
  creating objects from a subclass. Instead, normal method lookup rules apply
to initialize and only the first matching copy is invoked.

* When writing an initialize method for a class that explicitly uses
  inheritance, use super to initialize the parent class. The same rule applies
when you define an initialize_copy method.

### Item 9: Be Alert for Ruby’s Most Vexing Parse

* Setter methods can only be called with an explicit receiver. Without a
* receiver they will be parsed as variable assignments.

* When invoking a setter method from within an instance method use self as the
* receiver.

* You don’t need to use an explicit receiver when calling nonsetter methods. In
* other words, don’t litter your code with self.


### Item 10: Prefer Struct to Hash for Structured Data

Struct can take a block for defining methods

    Reading = Struct.new(:date, :high, :low) do def mean
     (high + low) / 2.0 end
    end



