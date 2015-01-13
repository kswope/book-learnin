# Ruby-Study Random Notes

-----

## BOOK: Practical Object-Oriented Design in Ruby

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




## BOOK: Ruby Cookbook

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

Things to do with a Regexp (not from book, my own musings)

  re = /this/im

  'this'.gsub(re, 'that')
  'this'.gsub!(re, 'that')

  'this' =~ re #=> 0
  re =~ 'this' #=> 0


Regexp::union (my really uncreative example)

    victim = 'this is my string'
    re = Regexp.union('this', 'string')
    victim.gsub!(re, '_')
    puts victim #=> "_ is my _"




