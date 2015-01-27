# Ruby Book Notes 

_Just my notes from various books/docs on ruby.  This is public only because I don't
want to waste a github private slot, so don't look._


- [Practical Object-Oriented Design in Ruby](#practical-object-oriented-design-in-ruby)
- [Ruby Cookbook](#ruby-cookbook)
- [Rails 4 Test Prescriptions](#rails-4-test-prescriptions)
- [Effective Ruby](#effective-ruby)
- [RSpec Docs](#rspec-docs)
- [ActiveRecord Docs](#activerecord-official-docs)
- [FactoryGirl Docs](#factorygirl-docs)
- [Design Patterns In Ruby](#design-patterns-in-ruby)

-----

## Practical Object-Oriented Design in Ruby

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




## Ruby Cookbook

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




## Rails 4 Test Prescriptions 


##### Prescriptions

1. Use the TDD process to create and adjust your code’s design in small,
  incremental steps.

2. In a test-driven process, if it is difficult to write tests for a feature,
  strongly consider the possibility that the underlying code needs to be
changed.

3. Initializing objects is a good starting place for a TDD process. Another good
  approach is to use the test to design what you want a successful interaction
of the feature to look like.

4. When possible, write your tests to describe your code’s behavior, not its
  implementation.

5. Keeping your code as simple as possible allows you to focus complexity on the
  areas that really need complexity.

6. Choose your test data and test-variable names to make it easy to diagnose
  failures when they happen. Meaningful names and data that doesn’t overlap are
helpful.

7. Test isolation makes it easier to understand test failures by limiting the
   scope of potential locations where the failure might have occurred.

8. Your tests are also code. Specifically, your tests are code that does not
   have tests.

9. If you find yourself writing tests that already pass given the current state
   of the code, that often means you’re writing too much code in each pass.

10. Refactoring is where a lot of design happens in TDD, and it’s easiest to do
    in small steps. Skip it at your peril.

11. Try to extract methods when you see compound Booleans, local variables, or
    inline comments.

12. Fixtures are particularly useful for global semi-static data stored in the
database.

13. Your go-to build strategy for factory_girl should be build_stubbed unless
there is a need for the object to be in the database during the test.

14. Avoid defining associations automatically in factory_girl definitions. Set
them test by test, as needed. You’ll wind up with more manageable test data.

-------



##### Setting up RSpec (for minitesters)

    group :development, :test do 
      gem 'rspec-rails', '~> 3.1'
    end

    $ rails generate rspec:install

##### Details (better details in [doc notes](#rspec-docs))

The actual spec is defined with it(), which takes an optional string argument
that documents the spec, and then a block that is the body of the spec. The
string argument is not used internally to identify the spec—you can have
multiple specs with the same description string.

For single-line tests in which a string description is unnecessary, we use
specify to make the single line read more clearly, such as this:

    specify { expect(user.name).to eq("fred") }

Why not just use it('') instead of specify() , I'm confused, looks better?

expect() takes any object as an argument and returns ExpectationTarget

ExpectationTarget holds on to the object and itself responds to two messages,
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



> Both to and not_to are ordinary Ruby
methods that expect as an argument an RSpec matcher. There's nothing special
about an RSpec matcher; at base it's just an object that responds to a matches?
method. There are several predefined matchers and you can write your own.


    let(:project){ Project.new }
    let(:task){ Task.new }

> Using let, you can make a variable available within the current describe
> without having to place it inside the before block and without having to make
> it an instance variable.


This version of let() will always run, its not lazy

    let!(:project){ Project.new }


> Any matcher of the form be_whatever or be_a_whatever assumes an associated
> whatever? method—with a question mark—on the actual object and calls it.


    expect(task).not_to be_complete
    task.mark_completed
    expect(task).to be_complete



All work as pending

    it 'something'

    it 'something', :pending do
    end

    it 'something' do
      pending 'not ready'
    end
  
> In RSpec 3 all pending specs are actually run if there is code in the block part
of the spec. The code is executed, with any failure in the pending spec treated
as a pending result, rather than a failure result. However, if the code in the
pending spec passes, you'll get an error that effectively means, "You said this
was pending, but lo and behold, it works. Maybe it's not actually pending
anymore; please remove the pending status."

( NOTE: The following doesn't seem quite right )
> If you want the spec to not run, and not test for whether it works, employ the
preceding syntax but use skip instead of pending. Alternative, you can prefix
the method name with x, as in xit or xdescribe. A skipped test will not run,
meaning you won't get any notification if the test suddenly starts to pass.



Rationale for not putting business logic in controller (in this case its put
inside a CreatesProject factory:

> We’ve been able to cover the controller logic in just these two short tests
> because we placed the business logic in the action object. If we hadn’t, all
> those tests we wrote for CreatesProject would be part of the controller test
> suite. As controller tests, they would run slower. More importantly, the
> tests would potentially be separated from the code where the expected failure
> would occur, making them less likely to drive design and less likely to be
> useful in trou- bleshooting.

> We want to make the controller test completely isolated from the action
> object that it interacts with. The key insight is that the controller test
> needs to test only the behavior of the controller itself—the fact that the
> controller calls the action object with the correct parameters and uses the
> values as expected. Whether the action object works correctly or even if it
> exists is a problem for the action object test. When testing the controller,
> the controller’s behavior is what’s important, not the action object.



> Debugging is twice as hard as writing the code in the first place. Therefore,
> if you write the code as cleverly as possible, you are, by definition, not
> smart enough to debug it.


1. A test is straightforward if its purpose is immediately understandable.

2. A test is well defined if running the same test repeatedly gives the same result.

3. A test is independent if it does not depend on any other tests or external
   data to run.

4. A truthful test accurately reflects the underlying code—it passes when the
   underlying code works, and fails when it does not. This is easier said than
   done.


And here we have an inadvertent admission, TDD is bullshit.  TDD is a little
test first, and a lot test after.

> When the main cases are done, you try to think of ways to break the existing
> code. Sometimes you’ll notice something as you’re writing code to pass a
> previous test, like, “Hey, I wonder what would happen if this argument were
> nil?” Write a test that describes what the output should be and make it pass.
> Refactoring gets increasingly important here because special cases and error
> conditions tend to make code complex, and managing that complexity becomes
> really important to future versions of the code. The advantage of waiting to
> do special cases at the end is that you already have tests to cover the
> normal cases, so you can use those to check your new code each step of the
> way.






When you break out related attributes into their own class, as in this Name
example (below), you'll often find it's much easier to add complexity when you have a
dedicated place for that logic. When you need middle names or titles, it's
easier to manage that in a separate class than it would be if you had a half
implementation of names in multiple classes.  You'll also find that these small
classes are easy to test because Name no longer has a dependency on the
database or any other code. Without dependencies, it's easy to set up and write
fast tests for name logic.

    class Name

      attr_reader :first_name, :last_name

      def initialize(first_name, last_name)
        @first_name, @last_name = first_name, last_name
      end

      def full_name
        "#{first_name} #{last_name}"
      end

      def sort_name
      "#{last_name}, #{first_name}"
      end

    end

    class User < ActiveRecord::Base

      delegate :full_name, :sort_name, to: :name #<-- name

      def name #<-- name
        Name.new(first_name, last_name)
      end

    end



Two styles writing tests with multiple assertions

    it "marks a task complete" do
      task = tasks(:incomplete)
      task.mark_complete
      expect(task).to be_complete
      expect(task).to be_blocked
      expect(task.end_date).to eq(Date.today.to_s(:db))
      expect(task.most_recent_log.end_state).to eq("completed")
    end

    describe "task completion" do
      let(:task) {tasks(:incomplete)}
      before(:example) { task.mark_complete }
      specify { expect(task).to be_complete }
      specify { expect(task).to be_blocked }
      specify { expect(task.end_date).to eq(Date.today.to_s(:db)) }
      specify { expect(task.most_recent_log.end_state).to eq("completed") }
    end


> The tradeoff is pretty plain: the one-assertion-per-test style has the
advantage that each assertion can fail independently—when all the assertions
are in a single test, the test bails on the first failure. In the all-in-one
test, if expect(task).to be_complete fails, you won’t even get to the check for
expect(task).to be_blocked. If all the assertions are in separate tests,
everything runs indepen- dently but it’s harder to determine how tests are
related. There are two signif- icant downsides to the one-assertion style:
first, there can be a significant speed difference since the
single-assertion-per-test version will run the com- mon setup multiple times,
and second, the one-assertion style can become difficult to read, especially if
the setup and test wind up with some distance between them.

> Often I compromise by making my first pass at TDD in the one-assertion-per-
test style, which forces me to work in baby steps and gives me a more accurate
picture of what tests are failing. When I’m confident in the correctness of the
code, I consolidate related assertions, giving me the speed benefit moving
forward.


About shoulda matchers (book discourages)

    describe Task do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
    it { should ensure_length_of(:name) }
    end

> Tests like that are not particularly valuable for a TDD process because they
are not about the design of new features. If you’re doing the TDD process, you
shouldn’t start from the idea that your Task belongs to a Project. Rather, as
you describe features the relationship is implied from the feature tests that
you’re writing. More operationally, this means that in a good TDD process, any
condition in the code that would cause a direct test like those Shoulda
matchers to fail would also cause another test to fail. In which case, what’s
the point of the Shoulda matcher?


##### Testing ActiveRecord Finders

> Be aggressive about extracting compound finder statements to their own
method, in much the same way and for much the same reason as I recommended
for compound Boolean logic. The methods are easier to understand
and reuse if they are bound together behind a method name that defines the
intent of the method. When we talk about mock objects you'll also see that
having finders called behind other methods makes it much easier to avoid
touching the database when you don't need to.



##### Shared example

Directory spec/support is loaded by default rails_helper.rb before specs are
run.  Put shared example definitions in there.

    RSpec.shared_examples "sizeable" do
      let(:instance) { described_class.new } #<--- notice described_class.new

      it "knows a one-point story is small" do
        allow(instance).to receive(:size).and_return(1)
        expect(instance).to be_small
      end

      it "knows a five-point story is epic" do
        allow(instance).to receive(:size).and_return(5)
        expect(instance).to be_epic
      end
    end

Note be_epic and be_small are predicate matchers for the methods small?() and epic?()

In spec files


    RSpec.describe Task do
      it_should_behave_like "sizeable"
    end


> There are a couple of other ways to invoke a shared example group - RSpec
defines synonymous methods include_examples and it_behaves_like.


> When invoking the group, you can also have the it_should_behave_like method
take a block argument. Inside that block, you can use let statements to define
variables, which are then visible to the shared example specs. In other words,
an alternative to creating an instance with described_class is to place the burden
on the calling spec to create a variable and give it an appropriate name in the
it block.

##### Write Your Own RSpec Matchers

    RSpec::Matchers.define :be_of_size do |expected|
      match do |actual|
        actual.total_size == expected
      end
    end

Remember: the expected value is the value defined by the test, and the actual
value is the value defined by the code. Here is the form in which the matcher
gets called:

    expect(actual_value).to be_of_size(expected_value)



#### Adding Data to Tests

Why Fixtures Are a Pain

* Fixtures are global
* Fixtures are spread out
* Fixtures are distant
* Fixtures are brittle


##### FactoryGirl basic factory creation

* build(:project, ...) returns model instance without saving to database

* create(:project, ...) returns model instance and saves to database

* attributes_for(:project) returns a hash of all the attributes in the factory
that are suitable for passing to AR#new or AR#create.  Used most often for creating
hash that will be sent as params to a controller test.

* build_stubbed(:project), which is almost magical. Like build, it returns an
unsaved model object. Unlike build, it assigns a fake ActiveRecord ID to the
model and stubs out database-interaction methods (like save) such that the test
raises an exception if they are called.

This is the strategy by which I determine which of these methods to use:

* Use create only if the object absolutely must be in the database. Typically,
this is because the test code must be able to access it via an ActiveRecord
finder. However, create is much slower than any of the other methods, so it’s
also worth thinking about whether there’s a way to structure the code so that
persistent data is not needed for the test.

* In all other cases, use build_stubbed, which does everything build does, plus
more. Because a build_stubbed object has a Rails ID, you can build up real
Rails associations and still not have to take the speed hit of saving to the
database.

##### Associations and Factories

Create a project instance to go with factory, (weird syntax) (and arent those
supposed to be methods, why are there colons in there?)

    FactoryGirl.define do 
      factory :task do
        title: "To Something" 
        size: 3
        project
      end 
    end
    task = FactoryGirl.create(:task)

Creates a factory for both task and project.

> By default, however, even if you call the parent factory with build, the
subordinate factory is still called with create. This is a side effect of how
Rails manages associations. The associated object needs an ID so that the
parent object can link to it, and in Rails you get an ActiveRecord ID only when
an ActiveRecord instance is saved to the database.

> As a result, even if you use the build strategy specifically to avoid slow
and unnecessary database interaction, if the factory has associations you will
still save objects to the database. Since those associated factories may
themselves have associations, if you aren’t careful you can end up saving a lot
of objects to the database, resulting in prohibitively slow tests.

> It’s exactly this characteristic of factory_girl that has made it unwelcome
in some circles, particularly if the people in those circles have to maintain
large, unwieldy test suites. Factory-association misuse can be a big cause of a
slow test suite, as tests create many more objects than they need to because of
factory_girl associations.



> Since the build_stubbed strategy assigns an ID to the objects being created,
using build_stubbed sidesteps the whole issue. If a factory with associations
is instantiated using build_stubbed, then by default all the associations are
also invoked using build_stubbed. That solves the problem as long as you always
use build_stubbed.

> My preferred strategy is to not specify attributes in factories at all, and if I need associated objects in a specific test, I explicitly add them to the test at the point they’re needed.
Why?

> * The surest way to keep factory_girl from creating large object trees is to not define large object trees.

> * Tests that require multiple degrees of associated objects often indicate
improperly factored code. Making it a little harder to write associations in
tests nudges me in the direction of code that can be tested without
associations.

_I'm not sure about this advice, what if you have lots of foreign key
constraints, or models that are closely tied together_




## Effective Ruby


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

    Reading = Struct.new(:date, :high, :low) do 
      def mean
        (high + low) / 2.0
      end
    end

* When dealing with structured data which doesn’t quite justify a new class
  prefer using Struct to Hash.

* Assign the return value of Struct::new to a constant and treat that constant
  like a class.

### Item 11: Create Namespaces by Nesting Code in Modules


Referring to KEY fails

    module SuperDumbCrypto
      KEY = "asf"
    end

    class SuperDumbCrypto::Encrypt
      def initialize (key=KEY)
      end
    end

    SuperDumbCrypto::Encrypt.new #=> uninitialized constant SuperDumbCrypto::Encrypt::KEY


Fully qualified referring to KEY works (not lexical because we closed the module first)

    module SuperDumbCrypto
      KEY = "asdf"
    end

    class SuperDumbCrypto::Encrypt
      def initialize (key=SuperDumbCrypto::KEY)
        puts key
      end
    end

    SuperDumbCrypto::Encrypt.new #=> 'asdf'



Lexically scoped call to KEY works (didn't close module)

    module SuperDumbCrypto
      KEY = "asdf"

      class SuperDumbCrypto::Encrypt
        def initialize (key=KEY)
          puts key
        end
      end

    end # module

    SuperDumbCrypto::Encrypt.new  #=> 'asdf'

### Item 12: Understand the Different Flavors of Equality

* Never override the equal? method. It's expected to strictly compare
objects and return true only if they're both pointers to the same
object in memory (i.e., they both have the same object_id).

* The Hash class uses the eql? method to compare objects used as
keys during collisions. The default implementation probably doesn't do what you
want. Follow the advice in Item 13 and then alias eql?  to == and write a
sensible hash method. (is this a big deal?)

* Use the == operator to test if two objects represent the same value.
Some classes like those representing numbers have a sloppy equality operator
that performs type conversion.

* case expressions use the === operator to test each when clause.
The left operand is the argument given to when and the right operand is the
argument given to case.

### Item 13: Implement Comparison via <=> and the Comparable Module

  * Implement object ordering by defining a <=> operator and including
the Comparable module.

* The <=> operator should return nil if the left operand can't be
compared with the right.

* If you implement <=> for a class you should consider aliasing eql?
to ==, especially if you want instances to be usable as hash keys, in which
case you should also override the hash method.

### Item 14 Share Private State Through Protected Methods

* Share private state through protected methods.

* Protected methods can only be called with an explicit receiver from
objects of the same class or when they inherit the protected methods
from a common superclass.

### Item 15 Prefer Class Instance Variables to Class Variables

@var is the same in both places

    class MyClass

      @var = :here_in_open

      def self.instance
        @var = :here_in_instance
      end

    end

use Module singleton if needed

    require 'singleton'

    class Klass
      include Singleton
      # ...
    end

    a,b  = Klass.instance, Klass.instance
    p a == b #=> true

* Prefer class instance variables to class variables.

* Classes are objects and so have their own private set of instance
variables.


### Item 16: Duplicate Collections Passed as Arguments before Mutating Them


Can use Marshal to make a deep copy, but won't work with some stuff like
closures, filehandles, etc

    irb> a = ["Monkey", "Brains"]
    irb> b = Marshal.load(Marshal.dump(a))

*  Method arguments in Ruby are passed as references, not values. Notable
   exceptions to this rule are Fixnum objects. (my note:  I think its actually
pass by value and those values are references)

* Duplicate collections passed as arguments before mutating them.

* The dup and clone methods only create shallow copies.

* For most objects, Marshal can be used to create deep copies when needed.

### Item 17: Use the Array Method to Convert nil and Scalar Objects into Arrays

    class Pizza
      def initialize (toppings)
        Array(toppings).each do |topping| 
          add_and_price_topping(topping)
        end 
      end
    # ...
    end

* Use the Array method to convert nil and scalar objects into arrays.

* Don’t pass a Hash to the Array method; it will get converted into a set
of nested arrays.

### Item 18: Consider Set for Efficient Element Inclusion Checking

Putting structs into a set example.  Use hash on date as the 'hash key' (set
uses a object.hash to determine if element to be added is unique).

>From Set Docs: The equality of each couple of elements is determined according
to Object#eql? and Object#hash, since Set uses Hash as storage.

    require('set')

    class AnnualWeather

      Reading = Struct.new(:date, :high, :low) do
        def eql? (other) date.eql?(other.date); end
        def hash; date.hash; end # prevents duplication of date
      end

      def initialize () 
        @readings = Set.new
      end

      def add(date, high, low)
        @readings << Reading.new(date, high, low)
      end

    end

    w = AnnualWeather.new
    w.add(2001, 50, 40) #=> added
    w.add(2002, 55, 45) #=> added
    w.add(2002, 60, 50) # won't add to set because of eql?() and hash() on date


* Consider Set for efficient element inclusion checking.

* Objects inserted into a Set must also be usable as hash keys.

* Require the “set” file before using Set.

### Item 19: Know How to Fold Collections with reduce

Examples:

    (1..10).inject(0, :+) #=> 55

    users.reduce([]) do |names, user| 
      names << user.name if user.age >= 21 names
    end 

* Always use a starting value for the accumulator.

* The block given to reduce should always return an accumulator. It’s fine to
mutate the current accumulator, just remember to return it from the block.


# Item 20: Consider Using a Default Hash Value


With a default value to Hash.new() we dont need the ||= line

    array.reduce(Hash.new(0)) do |hash, element|
      # hash[element] ||= 0 # Make sure the key exists.
      hash[element] += 1 # Increment the value.
      hash # Return the hash to reduce. 
    end

Use of fetch as a default value

    h = {}
    h[:accum] = h.fetch(:accum, 0) + 1


* Consider using a default Hash value.

* Use has_key? or one of its aliases to check if a hash contains a key. That
  is, don’t assume that accessing a nonexistent key will return nil.

* Don’t use default values if you need to pass the hash to code that assumes
invalid keys return nil.

* Hash#fetch can sometimes be a safer alternative to default values.


### Item 21: Prefer Delegation to Inheriting from Collection Classes

Core classes can be spiteful

    irb> class LikeArray < Array; end
    irb> x = LikeArray.new([1, 2, 3]) ---> [1, 2, 3]
    irb> y = x.reverse ---> [3, 2, 1]
    irb> y.class ---> Array doh!

* Prefer delegation to inheriting from collection classes.

* Don’t forget to write an initialize_copy method that duplicates the
  delegation target.

* Write freeze, taint, and untaint methods that send the corresponding
  message to the delegation target followed by a call to super.

### Item 22: Prefer Custom Exceptions to Raising Strings

    raise("coffee machine low on water")

same as

    raise(RuntimeError, "coffee machine low on water")

>Another reason to inherit from StandardError comes from the default
behavior of the rescue clause. As you know, you can omit the class
name when handling exceptions with rescue. In this case, it will
intercept any exception whose class (or superclass) is StandardError.
(The same is true when you use rescue as a statement modifier.)

Custom exception

    class TemperatureError < StandardError
      attr_reader(:temperature)
      def initialize (temperature)
        @temperature = temperature
        super("invalid temperature: #@temperature")
      end
    end


Avoid raising strings as exceptions; they're converted into generic
RuntimeError objects. Create a custom exception class instead.

Custom exception classes should inherit from StandardError and
use the Error suffix in their class name.

When creating more than one exception class for a project, start by
creating a base class that inherits from StandardError. Other exception
classes should inherit from this custom base class.

If you write an initialize method for your custom exception class
make sure to call super, preferably with an error message.

When setting an error message in initialize, keep in mind that setting
an error message with raise will take precedence over the one
in initialize.

### Item 23: Rescue the Most Specific Exception Possible


    begin
     task.perform
    rescue NetworkConnectionError => e
     # Retry logic...
    rescue InvalidRecordError => e
     # Send record to support staff...
    rescue => e # danger, could e not be original exception?
     service.record(e)
     raise
    ensure
     ...
    end


Store and reraise current exception if you are going to do something fancy with it so it
doesn't get overritten by another execption.  Also note a def can have a rescue clause.

    def send_to_support_staff (e)
     ...
    rescue
     raise(e)
    end


* Rescue only those specific exceptions from which you know how to
recover.

* When rescuing an exception, handle the most specific type first.
The higher a class is in the exception hierarchy the lower it should
be in your chain of rescue clauses.

* Avoid rescuing generic exception classes such as StandardError. If
you find yourself doing this you should consider whether what you
really want is an ensure clause instead.

* Raising an exception from a rescue clause will replace the current
exception and immediately leave the current scope, resuming
exception processing.


### Item 24: Manage Resources with Blocks and ensure

Example of made up Lock class, not that only calling with block 'unlocks' the lock

    class Lock
      def self.acquire

        lock = new # Initialize the resource.
        lock.exclusive_lock!

        if block_given? 
          yield(lock) # pass lock to block
        else
          lock # Act more like Lock::new and return lock handle.
        end

      ensure

        if block_given?
          lock.unlock if lock # Make sure it gets unlocked.
        end

      end 
    end

Idealized version of above with just method.

    def get_resource

      resource = Resource.get

      if block_given?
        yield(resource)
      end

    rescue
      # nothing special
    ensure

      if block_given?
        resource.release
      end

    end


* Write an ensure clause to release any acquired resources.

* Use the block and ensure pattern with a class method to abstract
away resource management.

* Make sure variables are initialized before using them in an ensure clause.


### Item 25: Exit ensure Clauses by Flowing Off the End

> Item 24 makes the point that using an ensure clause is the best way to manage
 resources in the presence of exceptions. More generally, ensure can be used
 to perform any sort of housekeeping before leaving the current scope. It’s
 a fantastic, general-purpose cleaning product. But like any useful tool,
 ensure comes with a warning label and some sharp edges.

> One of the features that both rescue and ensure share is the ability to
terminate exception processing. You already know that rescue catches
exceptions. From within rescue you can choose to cancel propagation and deal
with the error, resuming normal control flow. You can also restart exception
processing by raising the original exception or by creating a new one.

> You probably don’t expect that an ensure clause can alter control flow and
  swallow exceptions. That’s certainly not its primary purpose. Nevertheless,
  it’s possible, fairly simple, and slightly subtle. ALL IT TAKES IS AN
  EXPLICIT RETURN STATEMENT:

The following return in ensure will eat exceptions if there are any and will
always be the return value for tricky(), which is just dumb code

    def tricky
      return 'horses'
    ensure
      return 'ponies' 
    end

next and break can also silently discard exceptions in interators

    items.each do |item|
      begin
        raise TooStrongError if item == 'lilac' 
      ensure
        next # Cancels exception, continues iteration.
      end
    end

* Avoid using explicit return statements from within ensure clauses. This
  suggests there’s something wrong with the logic in the method body.

* Similarly, don’t use throw directly inside ensure. You probably meant to
  place throw in the body of the method.

* When iterating, never use next or break in an ensure clause. Ask yourself if
  you actually need the begin block inside the iteration. It might make more
  sense to invert the relationship, placing the itera- tion inside the begin.

* More generally, don’t alter control flow in an ensure clause. Do that in a
  rescue clause instead. Your intent will be much clearer.


### Item 26: Bound retry Attempts, Vary Their Frequency, and Keep an Audit Trail

    retries = 0
    begin
      service.update(record)
    rescue VendorDeadlockError => e
      raise if retries >= 3
      retries += 1
      logger.warn("API failure: #{e}, retrying...")
      sleep(5 ** retries)
      retry
    end

* Never use retry unconditionally; treat it like an implicit loop in your code.
  Create a variable outside the scope of a begin block and re-raise the
exception if you’ve hit the upper bound on the retry limit.

* Maintain an audit trail when using retry. If retrying problematic code
  doesn’t go well you’ll want to know the chain of events that led up to the
final error.

* When using a delay before a retry, consider increasing it within each rescue
  to avoid exacerbating the problem.

### Item 27: Prefer throw to raise for Jumping Out of Scope




    match = catch(:jump) do 
      @characters.each do |character|
        @colors.each do |color|
        if player.valid?(character, color)
          throw(:jump, [character, color]) end
        end 
      end
    end

> As you can see, catch takes a symbol to use as the label and a block to
> execute. If throw is used in that block with the same label then catch will
> terminate the block and return the value given to throw. You don’t have to
> pass a value to throw either; it’s completely optional. If you omit the value
> it will be nil, or if throw isn’t called during the execu- tion of the block
> then catch will return the last value of its block. The only mandatory part
> of the throw invocation is the label symbol. If the throw label doesn’t match
> the catch label the stack will unwind look- ing for a matching catch,
> eventually turning into a NameError excep- tion if one can’t be found.

> If you find yourself using exceptions purely for control flow you might want to
consider using catch and throw instead. But if you find yourself using catch
and throw too often, you’re probably doing something wrong.


* Prefer using throw to raise when you need complicated control flow. An added
  bonus with throw is that you can send an object up the stack, which becomes
the return value of catch.

* Use the simplest control structure possible. You can often rewrite a catch
  and throw combination as a pair of method calls that simply use return to
jump out of scope.


### Item 28: Familiarize Yourself with Module and Class Hooks

__My Note: I'll probably always regret getting fancy with this stuff unless I'm
writing something like rails or rspec.__

* All of the hook methods should be defined as singleton methods.

* The hooks that are called when a method is added, removed, or undefined only
  receive the name of the method, not the class where the change occurred. Use
the value of self if you need to know this.

* Defining a singleton_method_added hook will trigger itself.

* Don’t override the extend_object, append_features, or prepend_features
  methods. Use the extended, included, or prepended hooks instead.


### Item 29: Invoke super from within Class Hooks

> Keep in mind that since modules can insert class hooks, it’s not always
> obvious when the hook you’re writing might override another one higher up in
> the inheritance hierarchy. Using super is good way to future-proof your
> code, but ultimately, you’ll have to use your best judgment.

 
### Item 30: Prefer define_method to method_missing


Method missing screws up duct-typing and makes objects obscure.

Following example: rather than inheriting from Hash, delegates to an internal hash instead (probably should use Forwardable)

    class HashProxy
      Hash.public_instance_methods(false).each do |name|
        define_method(name) do |*args, &block|
          @hash.send(name, *args, &block)
        end
      end
      def initialize
        @hash = {}
      end
    end

* Prefer define_method to method_missing.

* If you absolutely must use method_missing consider defining
respond_to_missing?.


### Item 31: Know the difference between the Variants of eval

* Methods defined using instance_eval or instance_exec are singleton
methods.

* The class_eval, module_eval, class_exec, and module_exec methods
can only be used with classes and modules. Methods defined with
one of these become instance methods.

### Item 32: Consider Alternatives to Monkey Patching

* While refinements might not be experimental anymore, they're still
subject to change as the feature matures.

* A refinement must be activated in each lexical scope in which you
want to use it.

### Item 33: Invoking modified methods with alias chaining

Add logging to any method

    module LogMethod

      def log_method (method)

        # Choose a new, unique name for the method.
        orig = "#{method}_without_logging".to_sym

        # Make sure name is unique.
        if instance_methods.include?(orig)
          raise(NameError, "#{orig} isn't a unique name")
        end

        # Create a new name for the original method.
        alias_method(orig, method)

        # Replace original method.
        define_method(method) do |*args, &block|
          $stdout.puts("calling method '#{method}'")
          result = send(orig, *args, &block)
          $stdout.puts("'#{method}' returned #{result.inspect}")
          result
        end

      end

    end

    irb> Array.extend(LogMethod)
    irb> Array.log_method(:first)

    irb> [1, 2, 3].first
    calling method 'first'
    'first' returned 1
    ---> 1

    irb> %w(a b c).first_without_logging
    ---> "a"

* When setting up an alias chain, make sure the aliased named is
unique.

* Consider providing a method that can undo the alias chaining.

### Item 34: Consider supporting differences in Proc Arity

* Unlike weak Proc objects, their strong counterparts will raise an
  ArgumentError exception if called with the wrong number of arguments.

* You can use the Proc#arity method to find out how many arguments a Proc
object expects. A positive number means it expects that exact number of
arguments. A negative number, on the other hand, means there are optional
arguments and it is the ones’ com- plement of the number of required arguments.


### Item 35: Think Carefully Before Using Module Prepending

    module MyModule
      def say
        print " MyModule 1 "
        super
      end
    end

    class Parent
      def say
        print " Parent "
      end
    end

    class Child < Parent
      # include MyModule # <-----  include
      prepend MyModule # <-----  prepend
      def say
        print " Child "
        super
        puts
      end
    end

    # include MyModule
    Child.new.say #=> " Child  MyModule  Parent "

    # prepend MyModule, runs say() in MyModule first
    Child.new.say #=> " MyModule  Child  Parent "


* Using the prepend method inserts a module before the receiver in the class
hierarchy, which is much different than include, which inserts a module
between the receiver and its superclass.

* Similar to the included and extended module hooks, prepending a module
  triggers the prepended hook.


### Item 39: Strive for Effectively Tested Code

* Use fuzzing and property-based testing tools to help exercise both the happy and exception paths of your code.

* Test-code coverage can give you a false sense of security since exe- cuted code isn’t necessarily correct code.

* It’s much easier to test a feature while you’re writing it.

* Before you start to search for the root cause of a bug, write a test
that fails because of it.

* Automate your tests as much as possible.

### Item 41: Be Aware of IRB's Advanced Features

* Define custom IRB commands in the IRB::ExtendCommandBundle
module or a module that is then included into IRB::ExtendCommand
Bundle.

* Use the underscore _ variable to access the result of the last
expression.

* The irb command can be used to start a new session and change
the current evaluation context to an arbitrary object.

* Consider the popular Pry gem as an alternative to IRB.


### Item 42: Manage Gem Dependencies with Bundler  

* In exchange for a little bit of flexibility you can load all of the gems
specified in your Gemfile by using Bundler.require after loading
Bundler.

* When developing an application, list your gems in the Gemfile and
add the Gemfile.lock file to your version-control system

* When developing a RubyGem, list your gem dependencies in the
gem-specification file and do not include the Gemfile.lock file in
your version-control system.


### Item 43: Specify an Upper Bounds for Gem Dependencies


    gem('money', '>= 5.1.0', '< 5.2.0')
    gem('money', '~> 5.1.0') # same (somehow)

> The pessimistic version operator creates a range of version numbers by
  manipulating the version string to its right. In this example, the lower bound
  of the range turns into “>= 5.1.0”. The upper bound is created in two steps.
  First, the rightmost digit is removed from the version string, so 5.1.0
  becomes 5.1. Next, the new rightmost digit is incremented, changing 5.1 into
  5.2. The resulting number becomes the upper bound: “< 5.2.0”.

* Omitting an upper bound on a version requirement is akin to say- ing that
  your application or library supports all future versions of a dependency.

* Prefer an explicit range of version numbers over the pessimistic ver- sion
  operator.

* When releasing a gem to the public, specify the dependency version
  requirement as wide as you safely can with an upper bound that extends until
the next potentially breaking release.



## RSpec Docs


### Basic Structure

describe creates an ExampleGroup

    RSpec.describe Object do
    end

Alais for describe is context

    RSpec.context Object do
    end


ExampleGroups can be nested with describe or context (the omit the RSpec
receiver except in the outer example group)

    RSpec.describe Calculator do

      describe :another_describe do
        example 'example test' do
          expect(2).to eq(2)  
        end
      end

      context :another_context do
        example 'example test' do
          expect(2).to eq(2)  
        end
      end

    end


You can skip an entire example group by putting an 'x' before describe or context

    RSpec.describe Calculator do

      xdescribe :another_describe do
        example 'example test' do
          expect(2).to eq(2)  
        end
      end

      xcontext :another_context do
        example 'example test' do
          expect(2).to eq(2)  
        end
      end

    end


Examples are placed inside ExampleGroup

    RSpec.describe Object do

      it 'does something' do
      end

    end


Alternatives examples to 'it' or skip

      specify 'something' do
      end

      it 'does something' do
      end 

      example 'does something' do
      end


Mark examples as skip with 'x'

    xit 'something' do
    end

    xexample 'something' do
    end

    xspecify 'something' do
    end

Pending tests are expected to fail, if they don't fail its a failed test

    # successful pending test
    example 'example test' do
      expect(2).to eq(2) #<-- good  
      pending #<-- use before failing test
      expect(2).to eq(1) #<-- bad 
    end

    # failing pending test
    pending 'example test' do
      expect(2).to eq(2)  
    end


Why are skipped tests displayed as 'pending', exactly same as pending tests???

    Calculator
      example test (PENDING: No reason given)

### Build in Matchers

##### My assumed MVP matchers

    expect(actual).to eq(expected)  # passes if actual == expected
    expect(actual).to match(/expression/)
    expect(actual).to be_truthy   # passes if actual is truthy (not nil or false)
    expect(actual).to be true     # passes if actual == true
    expect(actual).to be_falsy    # passes if actual is falsy (nil or false)
    expect(actual).to be_nil      # passes if actual is nil
    expect { ... }.to raise_error(ErrorClass)

    expect(actual).to be_xxx         # passes if actual.xxx?
    expect(obj).to be_completed # if obj.completed?

    expect(actual).to have_xxx(:arg) # passes if actual.has_xxx?(:arg)
    expect(obj).to have_member(:one) # passes if obj.has_member?(:one)

    expect(actual).to include(expected)


##### Equivalence

    expect(actual).to eq(expected)  # passes if actual == expected
    expect(actual).to eql(expected) # passes if actual.eql?(expected)
    expect(actual).not_to eql(not_expected) # passes if not(actual.eql?(expected))

> Note: The new expect syntax no longer supports the == matcher.

##### Identity

    expect(actual).to be(expected)    # passes if actual.equal?(expected)
    expect(actual).to equal(expected) # passes if actual.equal?(expected)


##### Comparisons

    expect(actual).to be >  expected
    expect(actual).to be >= expected
    expect(actual).to be <= expected
    expect(actual).to be <  expected
    expect(actual).to be_within(delta).of(expected)

##### Regular expressions

    expect(actual).to match(/expression/)

##### Types/Classes

    expect(actual).to be_an_instance_of(expected) # passes if actual.class == expected
    expect(actual).to be_a(expected)              # passes if actual.is_a?(expected)
    expect(actual).to be_an(expected)             # an alias for be_a
    expect(actual).to be_a_kind_of(expected)      # another alias

##### Thruthiness

    expect(actual).to be_truthy   # passes if actual is truthy (not nil or false)
    expect(actual).to be true     # passes if actual == true
    expect(actual).to be_falsy    # passes if actual is falsy (nil or false)
    expect(actual).to be false    # passes if actual == false
    expect(actual).to be_nil      # passes if actual is nil
    expect(actual).to_not be_nil  # passes if actual is not nil

##### Expecting errors (notice the blocks, no arguments)

    expect { ... }.to raise_error
    expect { ... }.to raise_error(ErrorClass)
    expect { ... }.to raise_error("message")
    expect { ... }.to raise_error(ErrorClass, "message")

##### Expecting throws (notice the blocks, no arguments)

    expect { ... }.to throw_symbol
    expect { ... }.to throw_symbol(:symbol)
    expect { ... }.to throw_symbol(:symbol, 'value')

##### Yielding

    expect { |b| 5.tap(&b) }.to yield_control # passes regardless of yielded args

    expect { |b| yield_if_true(true, &b) }.to yield_with_no_args # passes only if no args are yielded

    expect { |b| 5.tap(&b) }.to yield_with_args(5)
    expect { |b| 5.tap(&b) }.to yield_with_args(Fixnum)
    expect { |b| "a string".tap(&b) }.to yield_with_args(/str/)

    expect { |b| [1, 2, 3].each(&b) }.to yield_successive_args(1, 2, 3)
    expect { |b| { :a => 1, :b => 2 }.each(&b) }.to yield_successive_args([:a, 1], [:b, 2])

##### Predicate matchers 

    expect(actual).to be_xxx         # passes if actual.xxx?
    expect(actual).to have_xxx(:arg) # passes if actual.has_xxx?(:arg)

##### Ranges (Ruby >= 1.9 only)

    expect(1..10).to cover(3)


##### Collection membership

    expect(actual).to include(expected)
    expect(actual).to start_with(expected)
    expect(actual).to end_with(expected)

    expect(actual).to contain_exactly(individual, items)
    # ...which is the same as:
    expect(actual).to match_array(expected_array)

##### Should syntax (old deprecated style)

    actual.should eq expected
    actual.should be > 3
    [1, 2, 3].should_not include 4


##### Compound Matcher Expressions

    expect(alphabet).to start_with("a").and end_with("z")
    expect(stoplight.color).to eq("red").or eq("green").or eq("yellow")
















## ActiveRecord Official Docs

### Basics (TODO)
http://guides.rubyonrails.org/active_record_basics.html

### Migrations (TODO)
http://guides.rubyonrails.org/active_record_migrations.html

### Validations (TODO)
http://guides.rubyonrails.org/active_record_validations.html

### Callbacks (TODO)
http://guides.rubyonrails.org/active_record_callbacks.html

### Associations (TODO)
http://guides.rubyonrails.org/association_basics.html

### Querying (TODO)
http://guides.rubyonrails.org/active_record_querying.html


## FactoryGirl Docs
http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md



## Design Patterns In Ruby

> It’s commonly agreed that the most useful thing about patterns is the way in
which they form a vocabulary for articulating design decisions during the
normal course of development conversations among programmers.

> So much for the principles originally cited by the GoF in 1995. To this
formidable set, I would like to add one more principle that I think is critical
to building, and actually finishing, real systems. This design principle comes
out of the Extreme Programming world and is elegantly summed up by the phrase
You Ain’t Gonna Need It (YAGNI for short). The YAGNI principle says simply that
you should not implement features, or design in flexibility, that you don’t
need right now. Why? Because chances are, you ain’t gonna need it later,
either.


##### [Template Method Pattern](http://en.wikipedia.org/wiki/Template_method_pattern)

_I think this is everthing like RoR, EventMachine, or a lot of other frameworks._

> 
The Template Method pattern is simply a fancy way of saying that if
you want to vary an algorithm, one way to do so is to code the invariant part
in a base class and to encapsulate the variable parts in methods that are
defined by a number of subclasses. The base class can simply leave the methods
completely undefined—in that case, the subclasses must supply the methods.
Alternatively, the base class can provide a default implementation for the
methods that the subclasses can override if they want.


##### [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern)

Also known as the *policy pattern*

>
* defines a family of algorithms
* encapsulate each algorithms
* makes the algorithms interchangeable within that family

>
With the Template Method pattern, we make our decision when we pick our
concrete subclass. In the Strategy pattern, we make our decision by selecting a
strategy class at runtime.

Simple strategy pattern can be implemented with a passed in code block.

    general.execute do |specific|
      ...
      specific.execute
      ...
    end

>
The easiest way to go wrong with the Strategy pattern is to get the interface
between the context and the strategy object wrong. Bear in mind that you are
trying to tease an entire, consistent, and more or less self-contained job out
of the context object and delegate it to the strategy. You need to pay
particular attention to the details of the interface between the context and
the strategy as well as to the coupling between them. Remember, the Strategy
pattern will do you little good if you couple the con- text and your first
strategy so tightly together that you cannot wedge a second or a third strategy
into the design.

>
The Strategy pattern is a delegation-based approach to solving the same problem
as the Template Method pattern. Instead of teasing out the variable parts of
your algo- rithm and pushing them down into subclasses, you simply implement
each version of your algorithm as a separate object. You can then vary the
algorithm by supplying dif- ferent strategy objects to the context

>
We have a couple of choices regarding how we get the appropriate data from the
context object over to the strategy object. We can pass all of the data as
parameters as we call methods on the strategy object, or we can simply pass a
reference to the whole context object to the strategy. (dont forget code blocks)

>
The motive behind the Strategy pattern is to supply the context with an object
that knows how to perform some variation on an algorithm.


##### [Observer pattern](http://en.wikipedia.org/wiki/Observer_pattern)

>
The observer pattern is a software design pattern in which an object, called
the subject, maintains a list of its dependents, called observers, and notifies
them automatically of any state changes, usually by calling one of their
methods.

[Observable in ruby stdlib](http://ruby-doc.org/stdlib-2.0.0/libdoc/observer/rdoc/Observable.html)

Code block as an observer

    fred = Employee.new('Fred', 'Crane Operator', 30000)
    fred.add_observer do |changed_employee|
      puts(“Cut a new check for #{changed_employee.name}!”) 
      puts(“His salary is now #{changed_employee.salary}!”)
    end

>
The key decisions that you need to make when implementing the Observer pattern
all center on the interface between the subject and the observer. At the simple
end of the spectrum, you might do what we did in the example above: Just have a
single method in the observer whose only argument is the subject. The GoF term
for this strategy is the pull method, because the observers have to pull
whatever details about the change that they need out of the subject. The other
possibility—logically enough termed the push method—has the subject send the
observers a lot of details about the change.

Example in AR (this might be a little too magical for me)

    class EmployeeObserver < ActiveRecord::Observer
      def after_create(employee)
        # New employee record created
      end
      def after_update(employee)
        # Employee record updated
      end
      def after_destroy(employee)
        # Employee record deleted
      end 
    end

> 
In a nice example of the Convention Over Configuration pattern, ActiveRecord
does not require you to register your observer: It just figures out that
EmployeeObserver is there to observe Employees, based on the class name.

>
The Observer pattern allows you to build components that know about the
activities of other components without having to tightly couple everything
together in an unmanageable mess of code-flavored spaghetti. By creating a
clean interface between the source of the news (the observable object) and the
consumer of that news (the observers), the Observer pattern moves the news
without tangling things up.

>
The interface between observer and observable can be a complex as you like, but
if you are building a simple observer, code blocks work well.

##### [Composite pattern](http://en.wikipedia.org/wiki/Composite_pattern)

>
Composite should be used when clients ignore the difference between
compositions of objects and individual objects.[1] If programmers find that
they are using multiple objects in the same way, and often have nearly
identical code to handle each of them, then composite is a good choice; it is
less complex in this situation to treat primitives and composites as
homogeneous.

Three parts

1. _component_ - Common interface or base class for all of your objects.
2. _leaf_ - Implements all Component methods
3. _composit_ - The composite is a component, but it is also a higher-level object that is built from subcomponents.
