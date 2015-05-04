# Book Notes 

_Just my notes from various books/docs on programming.  This is public only because I don't
want to waste a github private slot, so don't look._


- [Practical Object-Oriented Design in Ruby](#practical-object-oriented-design-in-ruby)
- [Ruby Cookbook](#ruby-cookbook)
- [Rails 4 Test Prescriptions](#rails-4-test-prescriptions)
- [Effective Ruby](#effective-ruby)
- [RSpec Docs](#rspec-docs)
- [ActiveRecord Docs](#activerecord-official-docs)
- [FactoryGirl Docs](#factorygirl-docs)
- [Design Patterns In Ruby](#design-patterns-in-ruby)
- [Metaprogramming Ruby](#metaprogramming-ruby)
- [Pickaxe Part I Ruby.new](#pickaxe-part-i-rubynew)
- [Pickaxe Part III Ruby Crystalized](#pickaxe-part-iii-ruby-crystalized)
- [The Well Grounded Rubyist](#the-well-grounded-rubyist)
- [Effective Javascript](#effective-javascript)
- [The Principles of Object-Oriented Javascript](#the-principles-of-object-oriented-javascript)
- [Speaking Javascript](#speaking-javascript)
- [JavaScript Patterns](#javascript-patterns)
- [Ember Guides and Tutorials](#ember-guides-and-tutorials)
- [You Don't Know JS](#you-dont-know-js)

TODO

- Underscore.js Docs
- Exceptional Ruby
- Algorithms in a Nutshell
- Practical Vim
- Code Complete
- Cracking the Coding Interview
- Elements of Programming Interviews
- Programming Interviews Exposed

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

15. Use partial doubles when you want to ensure most of your real object
behavior. Use full doubles when the behavior of the stubbed object doesn't
matter - only its public interface does.

16. The use of the allow_any_instance_of stub modifier often means the
underlying code being tested could be refactored with a more useful method to
stub.

17. If you're stubbing methods that do not belong to your program, think about
whether the code would be better if restructured to wrap the external behavior.

18. A stubbed method that returns a stub is usually okay. A stubbed method that
returns a stub that itself contains a stub probably means your code is too
dependent on the internals of other objects.

19. Don't mock what you don't own. (Not convinced by this one at all)

20. A controller test should test controller behavior. A controller test should
not fail because of problems in the model.

21. When testing for view elements, try to test for DOM classes that you
control rather than text or element names that might be subject to design
changes.

22. When testing a Boolean condition, make sure to write a test for both halves
of the condition.

23. By far the biggest and easiest trap you can fall into when dealing with
integration tests is the temptation to use them like unit tests.





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

#### Stubs, Mocks, Spies


>
A __stub__ is a fake object that returns a predetermined value for a method call
without calling the actual method on an actual object.

    allow(thing).to receive(:name).and_return("Fred")

>
A __mock__ is similar to a stub, but in addition to returning the fake value, a
mock object sets a testable expectation that the method being replaced will
actually be called in the test. If the method is not called, the mock object
triggers a test failure. You can write the following snippet to create a mocked
method call instead of a stub, using expect instead of allow:

    expect(thing).to receive(:name).and_return("Fred")


>
There is a third test-double pattern, called a spy. A spy is often declared like
a stub, but allows you to specify a testable expectation later in the test. Typically,
we would place the body of the test in between.

    allow(thing).to receive(:name).and_return("Fred")
    # body of test
    expect(thing).to have_received(:name)

Three types here:

    allow(thing).to receive(:name).and_return("Fred")


    expect(thing).to receive(:name).and_return("Fred")


    allow(thing).to receive(:name).and_return("Fred")
    ...
    expect(thing).to have_received(:name)


>
Using spies mitigates a common criticism of mock-object testing, which is that
it can be difficult to look at a mock test and see exactly what behavior is
being tested for. (I don't see how this is more clear that an ordinary mock,
doesn't a spy just turn a stub into a mock?)


>
In RSpec, as in many Ruby double libraries, there are two kinds of fake
objects. You can create entire objects that exist only to be stubs, which we'll
call full doubles, or you can stub specific methods of existing objects, which
we'll call partial doubles.


>
A partial double is useful when you want to use a "real" ActiveRecord object
but you have one or two dangerous or expensive methods you want to bypass.  A
full double is useful when you're testing that your code works with a specific
API rather than a specific object - by passing in a generic object that
responds to only certain methods, you make it hard for the code to assume
anything about the structure of the objects being coordinated with.



Creating full double

    twin = double(first_name: "Paul", weight: 100)


For when you know your double needs to mimic a specific object, RSpec provides
the concept of a verifying double. A verifying double checks to see whether
messages passed to the double are actually real methods in the application.
RSpec has a few methods to allow you to declare what to verify the double
against:

    instance_twin = instance_double("User")
    instance_twin = instance_double(User)
    class_twin = class_double("User")
    class_twin = class_double(User)
    object_twin = object_double(User.new)

_instance_double will not recognize methods defined via method_missing, object_double will_

instance_double uses method_defined? and class_double uses responds_to?


In addition to verifying the existence of the method, RSpec double verification
ensures that the arguments passed to the method are valid. The doubled
method will also have the same public/protected/private visibility as the
original method.  _(How does it do this?)_


>
You might use a full double object to stand in for an entire object that is
unavailable or prohibitively expensive to create or call in the test
environment.


Partial stub example (or is it a partial double spy?)

    # this is a pointless test
    it "stubs an object" do
      project = Project.new(name: "Project Greenlight")
      allow(project).to receive(:name) 
      expect(project.name).to be_nil # <--- this is pointless, only testing rspec-mocks
    end


Stubbing instances of an Class

    allow_any_instance_of(Project).to receive(:save).and_return(false)


The RSpec docs explicitly recommend not using this feature if possible, since
it is "the most complicated feature of rspec-mocks, and has historically
received the most bug reports."

>
A very common use of stub objects is to simulate exception conditions. If you
want your stubbed method to raise an exception, you can use the and_raise
method, which takes an exception class and an optional message:

    allow(stubby).to receive(:user_count).and_raise(Exception, "oops")


>
The return values of the stubbed method walk through the values passed to
and_return. Note that the values don't cycle; the last value is repeated over
and over again.

    allow(project).to receive(:user_count).and_return(1, 2)


>
The expectation is that some method takes a block argument, and we want to pass
through method and send arg to the block.

    allow(project).to receive(:method).and_yield("arg")

_Prescription 19. Don't mock what you don't own._

>
One reason to mock only methods you control is, well, that you control them.
One danger in mocking methods is that your mock either doesn't receive or
doesn't return a reasonable value from the method being replaced. If the method
in question belongs to a third-party framework, the chance that it will change
without you knowing increases and thus the test becomes more brittle.

I'm not sure about the above paragraph.  If a third party lib changes, your
stuff is going to break (or fail?) anyway.  Is it the difference between
failing and being brittle?

>
More importantly, mocking a method you don't own couples your test to the
internal details of the third-party framework. By implication, this means the
method being tested is also coupled to those internal details. That is bad, not
just if the third-party tool changes, but also if you want to refactor your
code; the dependency will make that change more complicated.

>
The solution, in most cases, is to create a method or class in your application
that calls the third-party tool and stubs that method (while also writing tests
to ensure that the wrapper does the right thing). 

_Is the above overkill?_


### Testing Controllers and Views

_Note: controller testing doesn't test routes_

Evaluating Controller Results

* Did it return the expected HTTP status code? RSpec provides the
__response.status__ object and the have _http_status_ matcher for this purpose.

* Did it pass control to the expected template or redirected controller action?
Here we have the __render_template__ and __redirect_to__ matchers.

* Did it set the values that the view will expect? For this we have the special
hash objects __assigns__, __cookies__, __flash__, and __session__.

>
Rails controller tests do not - I repeat, do not - follow the redirect.

Example of a controller test

    it "shows a task" do
      task = Task.create!
      get :show, id: task.id
      expect(response).to have_http_status(:success)
      expect(assigns(:task).id).to eq(task.id)
      expect(session[:previous_page]).to eq("task/show")
    end



>
I'm aggressive about moving controller logic that interacts with the model to
some kind of action object that doesn't have Rails dependencies. The controller
logic and controller testing then tends to be limited to correctly dispatching
successful and failed actions. That said, many Rails developers, notably
including David Heinemeier Hansson, find adding an extra layer of objects to be
overkill and think that worry about slow tests is misplaced. I recommend you
try both ways and see which one best suits you.

### Integration testing with Capybara


>
In a Rails context, the following are fodder for integration tests:
* The interaction between a controller and the model or other objects that
provide data
* The interaction between multiple controller actions that comprise a common
work flow.
* Certain security issues that involve the interaction between a user state
and a particular controller action.

>
These things, generally speaking, are not integration tests. Use unit tests
instead:
* Special cases of business logic, such as what happens if data is nil or has
an unexpected value
* Error cases, unless an error case genuinely results in a unique user
experience
* Internal implementation details of business logic

OMG THIS BOOK IS SO BORING.




<!-- END Prescriptions -->


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
compositions of objects and individual objects. If programmers find that they
are using multiple objects in the same way, and often have nearly identical
code to handle each of them, then composite is a good choice; it is less
complex in this situation to treat primitives and composites as homogeneous.

Three parts

1. _component_ - Common interface or base class for all of your objects.
2. _leaf_ - Implements all Component methods
3. _composit_ - The composite is a component, but it is also a higher-level
   object that is built from subcomponents.

>
...there is one unavoidable difference between a composite and a leaf: The
composite has to manage its children, which probably means that it needs to
have a method to get at the children and possibly methods to add and remove
child objects. The leaf classes, of course, really do not have any children to
manage; that is the nature of leafyness.

>
Problem: Application needs to manipulate a hierarchical collection of
"primitive" and "composite" objects. Processing of a primitive object is
handled one way, and processing of a composite object is handled differently.
Having to query the "type" of each object before attempting to process it is
not desirable.

##### [Iterator Pattern](http://en.wikipedia.org/wiki/Iterator_pattern)

>
Provide a way to access the elements of an aggregate object sequentially
without exposing its underlying representation

>
In other words, an Iterator provides the outside world with a sort of movable
pointer into the objects stored inside an otherwise opaque aggregate object.

>
To mix in Enumerable, you need only make sure that your internal iterator
method is named each and that the individual elements that you are going to
iterate over have a rea- sonable implementation of the <=> comparison operator.

    class Account
      def <=>(other)
        balance <=> other.balance
      end
      ...
    end

    class Portfolio
      include Enumerable
      def each(&block)
        @accounts.each(&block)
      end
      ...
    end


##### [Command Pattern](http://en.wikipedia.org/wiki/Command_pattern) 

Gang of four says:

>
Commands are an object-oriented replacement for callbacks.

What more is there to say?


##### [Adapter Pattern](http://en.wikipedia.org/wiki/Adapter_pattern)

Modify existing object dynamically to avoid an adapter (not sure why its here)

    bto = BritishTextObject.new('hello', 50.8, :blue)
    class << bto
      def color
        colour
      end
    end

same as but doesn't look as cool

    bto = BritishTextObject.new('hello', 50.8, :blue)
    def bto.color
      colour
    end

>
An adapter is an adapter only if you are stuck with objects that have the wrong
interface and you are trying to keep the pain of dealing with these ill-fitting
interfaces from spreading throughout your system.


#####[Proxy Pattern](http://en.wikipedia.org/wiki/Proxy_pattern)

>
A proxy, in its most general form, is a class functioning as an interface to
something else. The proxy could interface to anything: a network connection, a
large object in memory, a file, or some other resource that is expensive or
impossible to duplicate.

>
The Proxy pattern is essentially built around a little white lie. When the
client asks us for an object - perhaps the bank account object mentioned
earlier - we do indeed give the client back an object. However, the object that
we give back is not quite the object that the client expected. What we hand to
the client is an object that looks and acts like the object the client
expected, but is actually an imposter.

* Protection Proxy - proxy that controls access to an object
* Remote Proxy - local access to remote service/object
* Virtual Proxy - It pretends to be the real object, but it does not even have
a reference to the real object until the client code calls a method

Use method_missing for easy proxies:

    class AccountProxy

      def initialize(real_account)
        @subject = real_account
      end

      def method_missing(name, *args)
        puts("Delegating #{name} message to subject.")
        @subject.send(name, *args)
      end

    end


##### [Decorator Pattern](http://en.wikipedia.org/wiki/Decorator_pattern)

a.k.a Wrapper


>
A design pattern that allows behavior to be added to an individual object,
either statically or dynamically, without affecting the behavior of other
objects from the same class (only objects?)

    writer = CheckSummingWriter.new(TimeStampingWriter.new( NumberingWriter.new(SimpleWriter.new('final.txt'))))

Make writing wrappers easier for all the simple pass through methods by using Forwardable.

    require 'forwardable'

    class WriterDecorator

      extend Forwardable

      def_delegators :@real_writer, :write_line, :rewind, :pos, :close

      def initialize(real_writer)
        @real_writer = real_writer
      end

    end


>
The forwardable module is more of a precision weapon than the method_missing
technique. With forwardable, you have control over which methods you delegate.
Although you could certainly put logic in method_missing to pick and choose
which methods to delegate, the method_missing technique really shines when you
want to delegate large numbers of calls.


Wrapping methods

    w = SimpleWriter.new('out')

    class << w #<-- use this instead of def w.write_line
      alias old_write_line write_line #<-- because of this
      def write_line(line)
        old_write_line("#{Time.new}: #{line}")
      end
    end



##### [Singleton](http://en.wikipedia.org/wiki/Singleton_pattern)


Just use the module

    require 'singleton'

    class SimpleLogger
      include Singleton
      # Lots of code deleted...
    end

    SimpleLogger.instance



>
Properly applied, singletons are not global variables. Rather, they are meant
to model things that occur exactly once. Yes, because it occurs only once, you
can use a singleton as a unique communications conduit between bits of your
program. But don't do that.

Isn't every class and module a singleton? Its an actual object, and there's only one.


##### [Factory](http://en.wikipedia.org/wiki/Factory_method_pattern)

>
Factory method pattern is a creational pattern which uses factory methods to
deal with the problem of creating objects without specifying the exact class of
object that will be created.

Does "creating objects without specifying the exact class of object" mean that
every factory is capable of creating multiple types of objects, or that the
factory name doesn't specify the class type of the object returned?

>
The key thing that we discovered in this chapter is how both of these patterns
morphed in Ruby’s dynamic environment—specifically, how they became much sim-
pler. While the GoF concentrated on inheritance-based implementations of their
factories, we can get the same results with much less code by taking
advantage of the fact that in Ruby, classes are just objects. In Ruby we can
look up classes by name, pass them around, and store them away for future use.


##### [Builder](http://en.wikipedia.org/wiki/Builder_pattern)

>
The builder pattern is an object creation software design pattern. Unlike the
abstract factory pattern and the factory method pattern whose intention is to
enable polymorphism, the intention of the builder pattern is to find a solution
to the telescoping constructor anti-pattern. The telescoping constructor
anti-pattern occurs when the increase of object constructor parameter
combination leads to an exponential list of constructors. Instead of using
numerous constructors, the builder pattern uses another object, a builder, that
receives each initialization parameter step by step and then returns the
resulting constructed object at once.

Builder pattern is like a wind-up constructor.  I'm not sure how the following
code solves the "telescoping constructor anti-pattern" mentioned above.  I'm
not sure how the following code solves anything at all.  Why not just allow the
Computer class itself to build its object step by step?

    class Computer

      def initialize(drive_size, cd, memory)
        @drive_size, @cd, @memory = drive_size, cd, memory
      end

    end

    class ComputerBuilder

      attr_accessor :drive_size, :cd, :memory

      def build
        Computer.new(self.drive_size, self.cd, self.memory)
      end

    end

    builder = ComputerBuilder.new
    builder.drive_size = 700
    builder.cd = false
    builder.memory = 1000
    computer = builder.build


Good rationale for Builder Pattern from wikipedia

>
The builder pattern has another benefit. It can be used for objects that
contain flat data (html code, SQL query, X.509 certificate...), that is to say,
data that can't be easily edited. This type of data cannot be edited step by
step and must be edited at once. The best way to construct such an object is to
use a builder class.

>
The idea behind the Builder pattern is that if your object is hard to build, if
you have to write a lot of code to configure each object, then you should
factor all of that creation code into a separate class, the builder.

>
Builders, because they are in control of configuring your object, can also
prevent you from constructing an invalid object.


##### [Interpreter Pattern](http://en.wikipedia.org/wiki/Interpreter_pattern)

>
The Interpreter pattern is built around a very simple idea: Some programming
problems are best solved by creating a specialized language and expressing
the solution in that language.

>
Another clue that your problem might be right for the Interpreter pattern is
that you find yourself creating lots of discrete chunks of code, chunks that
seem easy enough to write in themselves, but which you find yourself combining
in an ever expanding array of combinations. Perhaps a simple interpreter could
do all of the combining work for you.

>
Interpreters typically work in two phases. First, the parser reads in the
program text and produces a data structure, called an abstract syntax tree
(AST). 

_I'm skipping most of this because I think ruby DSL's are a better option for
the rare occasion that the Interpreter Pattern would be applicable.  And this
stuff is so challanging that I'll forget it by tomorrow anyway._


##### Domain Specific Languages Chapter

Mostly skipping for now, maybe go back to it later.  I've delt with DSL often.


##### Meta-programming Chapter

Skipping.  Will do more with meta-programming with more indepth sources.


##### Convention Over Configuration Chapter

I'm a rails developer.  This stuff looks too familiar. 


## Metaprogramming Ruby

* An object is composed of a bunch of instance variables and a link to a class.

* The methods of an object live in the object’s class. (From the point of view
of the class, they’re called instance methods.)

* The class itself is just an object of class Class. The name of the class is
just a constant.

* Class is a subclass of Module. A module is basically a package of methods.
In addition to that, a class can also be instantiated (with new) or arranged in
a hierarchy (through its superclass).

* Constants are arranged in a tree similar to a file system, where the names
of modules and classes play the part of directories and regular constants play
the part of files.

* Each class has an ancestors chain, beginning with the class itself and going
up to BasicObject.

* When you call a method, Ruby goes right into the class of the receiver and
then up the ancestors chain, until it either finds the method or reaches the
end of the chain.

* When you include a module in a class, the module is inserted in the ancestors
chain right above the class itself. When you prepend the module, it is inserted
in the ancestors chain right below the class.

* When you call a method, the receiver takes the role of self.

* When you’re defining a module (or a class), the module takes the role of
self.

* Instance variables are always assumed to be instance variables of self.

* Any method called without an explicit receiver is assumed to be a method of
self.

* Refinements are like pieces of code patched right over a class, and they
override normal method lookup. On the other hand, a Refinement works in a
limited area of the program: the lines of code between the call to using and
the end of the file, or the end of the module definition.

You can use public_send in place of send if you want to be careful.

There is one important reason to use define_method over the more familiar def
keyword: define_method allows you to decide the name of the defined method at
runtime.

define_method is private so you cant define method on another class unless
you use the send() trick.  Same with method_missing.


__Dropping this book for now.  Getting fatigued by the plot driven slow motion
explainations, probably because I'm already familiar with the topic, so
new-to-me material is spread extra thin because of the plotting... might go
back to it later.__


## Pickaxe Part I Ruby.new

__skimming...__

Default value of Hash

    histogram = Hash.new(0) # The default value is zero

Don't forget there's a sub() along with that gsub()

    newline = line.sub(/Perl/, 'Ruby') # replace first 'Perl' with 'Ruby'
    newerline = newline.gsub(/Python/, 'Ruby') # replace every 'Python' with 'Ruby'


You have many ways to read input into your program. Probably the most traditional is to
use the method gets, which returns the next line from your program's standard input stream:

    line = gets
    print line

gets returns nil when done, so you can use this

    while line = gets
      print line
    end

ARGV contains each of the arguments passed to the running program

    p ARGV #=> [arg1, arg2, arg3]
    p ARGV[0] #=> arg1
    p ARGV.length #=> 3



Don't forget slicing an array

    a = [ 1, 3, 5, 7, 9 ] 
    a[1,3] #=>[3,5,7] 
    a[3, 1] # => [7] 
    a[-3,2] #=>[5,7]

Same as string, but doesn't accept regex

    s = '12345'
    s[0,2] #=> '12'
    s[/../] #=> '12' #<-- won't work with an array (don't know how it could)

Splat seems to work, makes sense, Array.[] is just a method

    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10][ *[0,3] ]

Select non-adjacent values in array with value_at

    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].values_at(1,3,5) #=> [1, 3, 5]

Ruby version of perl's splice - If the index to [ ]= is two numbers (a __start__
and a __length__) or a range, then those elements in the original array are
replaced by whatever is on the right side of the assignment. If the length is
zero, the right side is inserted into the array before the start position; no
elements are removed.

    a = [0, 1, 2, 3, 4, 5]
    a[2,4] = :cat
    a # => [0, 1, :cat] 

Word counter one liner I just made up

    "one two two three three three".scan(/[\w']+/).inject(Hash.new(0)){|a,v| a[v] +=1; a }

Block local variables (does anybody care?, maybe?, be more confident?)

    square = "some shape"
    sum = 0
    [1, 2, 3, 4].each do |value; square| #<-- can't touch outer square now
      square = value * value
      sum += square
    end

Add a buncha numbers together

    [1,3,5,7].inject(:+) # => 16


#### Enumerators—External Iterators

>
It’s also worth spending another paragraph looking at why Ruby’s internal
iterators aren’t always the best solution. One area where they fall down badly
is where you need to treat an iterator as an object in its own right (for
example, passing the iterator into a method that needs to access each of the
values returned by that iterator). It’s also difficult to iterate over two
collections in parallel using Ruby’s internal iterator scheme.  (When would
anybody ever want to pass an external iterator to a method?)

You can create an Enumerator object by calling the to_enum method (or its
synonym, enum_for) on a collection such as an array or a hash:

    a = [ 1, 3, "cat" ]
    h = { dog: "canine", fox: "vulpine" }

    # Create Enumerators
    enum_a = a.to_enum
    enum_h = h.to_enum
    enum_a.peek # => 1
    enum_a.entries # => [ 1, 3, "cat" ]
    enum_a.next # => 1
    enum_h.next # => [:dog, "canine"] enum_a.next # => 3
    enum_h.next # => [:fox, "vulpine"]

There's also peek, enteries


Most of the internal iterator methods—the ones that normally yield successive
values to a block—will also return an Enumerator object if called without a
block:

    e = [1,2,3].each_with_index
    e.next #=> [1, 0]


Ruby has a method called loop that does nothing but repeatedly invoke its
block. Typically, your code in the block will break out of the loop when some
condition occurs. But loop is also smart when you use an Enumerator—when an
enumerator object runs out of values inside a loop, the loop will terminate
cleanly. The following example shows this in action—the loop ends when the
three-element enumerator runs out of values. _You can also handle this in your
own iterator methods by rescuing the StopIteration exception, but because we
haven’t talked about exceptions yet, we won’t go into details here._

    short_enum = [1, 2, 3].to_enum 
    long_enum = ('a'..'z').to_enum
    loop do
      puts "#{short_enum.next} - #{long_enum.next}"
    end

Note from http://www.ruby-doc.org/core-2.2.0/Enumerator.html
Chaining enumerators lets you chain them together to create
new possiblities.

Enumerator mixes in Enumerable, and has these methods

    each
    each_with_index
    with_index # shorter version
    next
    peek
    rewind
    each_with_object
    with_object

Example

    %w[foo bar baz].map.with_index { |w, i| "#{i}:#{w}" }


#### Bocks for Transactions

    # read the counter using read lock
    File.open("counter", "r") {|f|
      f.flock(File::LOCK_SH)
      p f.read
    }


#### Blocks Can Be Objects

Here’s an example where we create a Proc object in one instance method and
store it in an instance variable. We then invoke the proc from a second
instance method.

    class ProcExample
      def pass_in_block(&action)
        @stored_proc = action
      end
      def use_proc(parameter)
        @stored_proc.call(parameter)
      end 
    end

    eg = ProcExample.new
    eg.pass_in_block { |param| puts "The parameter is #{param}" } 
    eg.use_proc(99)


#### Blocks can be closures

    def power_proc_generator
      value = 1
      lambda { value += value }
    end

    power_proc = power_proc_generator

    puts power_proc.call #=> 2
    puts power_proc.call #=> 4
    puts power_proc.call #=> 8


#### An Alternative Notation for lambda

    lambda { |params| ... }

    -> params { ... }
    proc1 = -> arg { puts "In proc1 with #{arg}" }
    proc2 = -> arg1, arg2 { puts "In proc2 with #{arg1} and #{arg2}" }
    proc3 = ->(arg1, arg2) { puts "In proc3 with #{arg1} and #{arg2}" }

    def my_while(cond, &body)
      while cond.call
        body.call
      end 
    end

    a = 0

    my_while ->{ a<3} do
      puts a
      a += 1
    end


Oh shit, procs can take blocks

    proc1 = lambda do |a, *b, &block|
      puts "a = #{a.inspect}"
      puts "b = #{b.inspect}" 
      block.call
    end

    proc1.call(1, 2, 3, 4) { puts "in block1" }

    # new syntax
    proc2 = -> a, *b, &block do 
      puts "a = #{a.inspect}"
      puts "b = #{b.inspect}" 
      block.call
    end

#### Sharing Functionality, Inheritance, Modules, and Mixins

The Comparable mixin adds the comparison operators (<, <=, ==, >=, and >), as
well as the method between?, to a class.  You must define <=> 'method', which
will also work allow sort.

    class DominantPair

      include Comparable
      attr_accessor :data

      def initialize(letter, number)
        @data = [letter, number]
      end

      def <=>(other)
        @data[1] <=> other.data[1]
      end

      def inspect
        "[#{data[0]},#{data[1]}]"
      end

    end

    a = DominantPair.new('a', 2)
    b = DominantPair.new('b', 3)
    c = DominantPair.new('c', 1)
    [a,b,c].sort #=> [[c,1], [a,2], [b,3]]
    a > c #=> true
    b > a #=> true
    c < b #=> true


The Enumerable mixin provides collection classes with several traversal and
searching methods, and with the ability to sort. The class must provide a
method each, which yields successive members of the collection. If
Enumerable#max, #min, or #sort is used, the objects in the collection must also
implement a meaningful <=> operator, as these methods rely on an ordering
between members of the collection.


    class DominantPairCollection

      include Enumerable

      def initialize(pairs)
        @pairs = pairs
      end

      def each
        @pairs.each do |pair|
          yield pair
        end
      end

    end

    a = DominantPair.new('a', 2)
    b = DominantPair.new('b', 3)
    c = DominantPair.new('c', 1)

    collection = DominantPairCollection.new([a,b,c])

    collection.each do |pair|
      p pair
    end


Do the same thing but with Forwardable

    require 'forwardable'
    class DominantPairCollection

      include Enumerable

      extend Forwardable
      def_delegators :@pairs, :each

      def initialize(pairs)
        @pairs = pairs
      end

    end

    a = DominantPair.new('a', 2)
    b = DominantPair.new('b', 3)
    c = DominantPair.new('c', 1)

    collection = DominantPairCollection.new([a,b,c])

    collection.each do |pair|
      p pair
    end


A mixin’s instance variables can clash with those of the host class or with
those of other mixins.

For the most part, mixin modules don’t use instance variables directly—they use
accessors to retrieve data from the client object. But if you need to create a
mixin that has to have its own state, ensure that the instance variables have
unique names to distinguish them from any other mixins in the system (perhaps
by using the module’s name as part of the variable name).

In general, a mixin that requires its own state is not a mixin—it should be
written as a class.

Liskov Substitution Principle: What this means is that you should be able to
substitute an object of a child class wher- ever you use an object of the
parent class—the child should honor the parent’s contract.

In the real world, there really aren’t that many true is a relationships.
Instead, it’s far more common to have has a or uses a relationships between
things. The real world is built using composition, not strict hierarchies.



Finally, we’ll offer a warning for Perl users. Strings that contain just digits
are not automatically converted into numbers when used in expressions.  Use the
Integer() *method* to convert the strings to integers.  Why not to_i ?

3.times { print "X " }
1.upto(5).to_a #=> [1, 2, 3, 4, 5] 
99.downto(95).to_a #=> [99, 98, 97, 96, 95]
50.step(80, 5).to_a # => [50, 55, 60, 65, 70, 75, 80]

10.downto(7).with_index.to_a #=> [[10, 0], [9, 1], [8, 2], [7, 3]]


Ranges and enumerators

e = (1..10).to_enum
e.next #=> 1
e.next #=> 2
e.next #=> 3

Ranges as Conditions  (I don't understand this at all, maybe more to come)

As well as representing sequences, ranges can also be used as conditional
expressions. Here, they act as a kind of toggle switch—they turn on when the
condition in the first part of the range becomes true, and they turn off when
the condition in the second part becomes true. For example, the following code
fragment prints sets of lines from standard input, where the first line in each
set contains the word start and the last line contains the word end:

    while line = gets
      puts line if line =~ /start/ .. line =~ /end/
    end


Ranges as intervals

    (1..10) === 5 # => true
    (1..10) === 15 # => false

    case car_age
    when 0..0
      puts "Mmm.. new car smell"
    when 1..2
      puts "Nice and new"
    when 3..9
      puts "Reliable but slightly dinged"
    when 10..29
      puts "Clunker"
    else
      puts "Vintage gem"
    end


Don't forget there's also a !~ along with =~

    File.foreach("testfile").with_index do |line, index|
      puts "#{index}: #{line}" if line !~ /on/
    end


Unlike sub and gsub, sub! and gsub! return the string only if the pattern was
matched. If no match for the pattern is found in the string, they return nil
instead. This means it can make sense (depending on your need) to use the !
forms in conditions.



The match operators are defined for both String and Regexp objects.

    /abc/.match "abc" #=> MatchData
    "abc".match(/abc/) #=> MatchData

Various methods of MatchData

    m = 'abcdef'.match(/(cd)/)
    m.begin(0) #=> 2
    m.captures #=> ["cd"]
    m.regexp #=> /(cd)/
    m.values_at(0,2,4) #=> ['cd', nil, nil]
    m.pre_match #=> "ab"
    m.post_match #=> "ef"
    m.captures[0] #=> ["cd"]
    m[0] #=> ["cd"]

MatchData#[] and MatchData.captures are not the same:

    m = 'abcdef'.match(/(cd)/)
    m.captures[0] #=> "cd"
    m[0] #=> "cd" (part of string that was matched)
    m.captures[1] #=> nil
    m[1] #=> "cd" #=> first memory
    m.captures[2] #=> nil
    m[2] #=> nil

    m[0] #=> "cd" (part of string that was matched)
    m[1] #=> "cd" #=> first memory


Earlier we noted that the sequences \1, \2, and so on, are available in the
pattern, standing for the nth group matched so far. The same sequences can be
used in the second argument of sub and gsub.


    "fred:smith".sub(/(\w+):(\w+)/, '\2, \1') #=> smith, fred
    "nercpyitno".gsub(/(.)(.)/, '\2\1') #=> encryption


_Good section on regexen, but I'll probably forget it all.  I'll remember its
here in case I need to reference it._



You won’t get an immediate error if you start a method name with an uppercase
letter, but when Ruby sees you calling the method, it might guess that it is a
constant, not a method invocation, and as a result it may parse the call
incorrectly.

By convention, methods names starting with an uppercase letter are used for
type conversion. The Integer method, for example, converts its parameter to an
integer.

Default arguments values can reference previous arguments.

    def surround(word, pad_width=word.length/2)
      "[" * pad_width + word + "]" * pad_width
    end

I know from experience that a argument can be a instance variable

    def my_meth(@my_var)
      ...
    end


You can use split to indicate a method that doesn't use any arguments but that
are perhaps used by a method in a superclass

    class Child < Parent
      def do_something(*not_used)
          # our processing
          super 
      end
    end

You can put the splat argument anywhere in a method’s parameter list, allowing
you to write this:

    def split_apart(first, *splat, last)

If you cared only about the first and last parameters, you could define this
method using this:

    def split_apart(first, *, last)

Private methods may not be called with a receiver, so they must be methods
available in the current object. 

As of Ruby 1.9, splat arguments can appear anywhere in the parameter list, and
you can intermix splat and regular arguments.

Didn't think of it before but a block param is a possible way to interject some
variable code into a chain 

    if operator =~ /^t/
      calc = lambda {|n| n*number }
    else
      calc = lambda {|n| n+number }
    end
    (1..10).collect(&calc).join(", ")



(This is just wrong)
If the last argument to a method is preceded by an ampersand, Ruby assumes that
it is a Proc object. It removes it from the parameter list, converts the Proc
object into a block, and associates it with the method.

Proof:

    procinator = Object.new

    def procinator.to_proc
      puts "called to_proc"
      Proc.new {|x| x}
    end


    p (1..3).map(&procinator) 

    outputs:
    called to_proc
    [1, 2, 3]



Ruby keyword arguments in 2.0!

    def search(field, genre: nil, duration: 120) 
      p [field, genre, duration ]
    end

    search(:title)
    search(:title, duration: 432)
    search(:title, duration: 432, genre: "jazz")


You can collect these extra hash arguments as a hash parameter—just prefix one
element of your argument list with two asterisks (a double splat).

    def search(field, genre: nil, duration: 120, **rest) 
      p [field, genre, duration, rest ]
    end



### Expressions


    a * b + c # => 5

Same as

    (a.*(b)).+(c) # => 5

Define operators like <<

    class Appender

      attr_accessor :data

      def initialize
        @data = ''
      end

      def <<(x)
        @data += x
      end

    end


    appender = Appender.new

    appender << 'a'
    appender << 'b'
    appender << 'c'

    p appender.data #=> 'abc'


Note: return self so we can chain

    def <<(x)
      @data += x
      self
    end

    appender << 'a' << 'b' << 'c' << 'd'



How to define [] and []= methods

    obj = Object.new

    def obj.[](*args)
      p args
    end

    obj[1,2,3] #=> [1,2,3]


    def obj.[]=(*args)
      p args # last arg is value of assignment
    end

    obj[1,2,3] = 4 #=> [1, 2, 3, 4]


Ruby is authoritarian about its assignment methods.  The value of an assignment
is _always_ the value of the parameter, the return value of the method is
discarded.

    class MyClass
      def val=(v)
        @v = v
        44
      end
    end

    o = MyClass.new
    p o.val = 1 #=> 1 (not 44)



Assignment isn't so obvious

    a=1,2,3,4   # a=[1,2,3,4] # WTH?  I've been wasting so much time typing brackets
    b=[1,2,3,4] # b=[1,2,3,4]

    a,b=1,2,3,4    # a=1, b=2 
    c,=1,2,3,4     # c=1

    # look again
    c = 1,2,3,4
    p c #=> [1,2,3,4]
    c, = 1,2,3,4 #=> value of assignment is [1,2,3,4]
    p c #=> 1  but c is only 1

Splat works on rvalues

    a, b, c, d, e = *(1..2), 3, *[4, 5] # a=1, b=2, c=3, d=4, e=5

Seems to do something with ranges too

    a = *(1..6)
    a #=> [1, 2, 3, 4, 5, 6]

Splat can be applied to lvalues too (exactly one - works like a sponge)

    a,*b=1,2,3 # a=1, b=[2,3] 
    a,*b=1 # a=1, b=[]

    *a,b=1,2,3,4         # a=[1,2,3], b=4
    c,*d,e=1,2,3,4       # c=1, d=[2,3], e=4
    f,*g,h,i,j=1,2,3,4   # f=1, g=[], h=2, i=3, j=4

I always forget this thing

    var ||= "default value"

defined? returns useful values too

    defined? 1           #=> "expression"
    defined? dummy       #=> nil
    defined? printf      #=> method
    defined? String      #=> 'constant'
    defined? $_          #=> 'global-variable'
    defined? Math::PI    #=> "constant"
    defined? a = 1       #=>  "assignment"
    defined? 42.abs      #=> "method"
    defined? nil         #=> "nil"

In addition to the boolean operators, Ruby objects support comparison using the
methods ==, ===, <=>, =~, eql?, and equal?  All but <=> are defined in class
Object but are often overridden by descendants to provide appropriate
semantics.

Both == and =~ have negated forms, != and !~. Ruby first looks for methods
called != or !~, calling them if found. If not, it will then invoke either ==
or =~, negating the result.


ruby has a if/then/else control structure? (the then is optional if formatted like below)

    if x == 1 then 
      do_1
    elsif x == 2 then 
      do_2
    else
      do_else
    end

then required for this formatting

    if artist == "Gillespie" then handle = "Dizzy" 
    elsif artist == "Parker" then handle = "Bird" 
    else handle = "unknown"
    end


The unless statement does support else, but most people seem to agree that it’s
clearer to switch to an if statement in these cases.

case also supports 'then formatting'

    kind = case year
           when 1850..1889 then "Blues"
           when 1890..1909 then "Ragtime"
           when 1910..1929 then "New Orleans Jazz" 
           when 1930..1939 then "Swing"
           else                 "Jazz"
           end



Don't forget the statment modifier form of while loop

    x = 0
    x += 1 while x < 100
    puts x #=> 100


The ruby do-while construct

    print "Hello\n" while false
    begin
      print "Goodbye\n"
    end while false


- break: terminates the immediately enclosing loop; control resumes at the
  statement following the block. 

- redo: repeats the current iteration of the loop from the start but
  withoutreevaluating the condition or fetching the next element (in an
iterator). 

- next: skips to the end of the loop, effectively starting the next iteration:

- retry: was removed in 1.9


break can return a value

    x = 0
    y = loop do
      break(x) if x > 50
      x += 1
    end

    p y #=> 51


### Exceptions

    raise # <--- reraises current exception
    raise "My stupid exception" #<---  raises RuntimeError with message


Raise a particular exception, using caller to automatically remove the current routine from the stack backtrace (useful for modules)

    raise InterfaceException, "Keyboard failure", caller #<-- particular exception with stacktrace

Remove more from backtrace

    caller[1..-2]

Creating custom exception

    class RetryException < RuntimeError
      attr :ok_to_retry
      def initialize(ok_to_retry)
        @ok_to_retry = ok_to_retry
      end
    end


Will I ever use catch and throw???

When Ruby encounters a throw, it zips back up the call stack looking for a
catch block with a matching symbol.  If the throw is called with the optional
second parameter, that value is returned as the value of the catch.

    x = catch(:mycatch) do
      throw(:mycatch, :hello)
    end

    p x #=> hello



Diversion with scan, match and captures.  Conclusions: Don't use scan for single
captures, use match.  Use named captures, so much better.

    str = 'this is a string right here'

    p str.scan(/\w+/) #=> ["this", "is", "a", "string", "right", "here"]
    p str.scan(/(\w+)/) #=> [["this"], ["is"], ["a"], ["string"], ["right"], ["here"]] 

    str = 'find me in all this stuff'
    p str.scan(/me/) #=> ["me"]

    # scan version
    str = 'first: Larry last:Wall'
    p str.scan(/first:\s*(.*)\s*last:\s*(.*)\s*/) #=> [["Larry ", "Wall"]]
    p str.scan(/first:\s*(.*)\s*last:\s*(.*)\s*/)[0][0] #=> Larry
    p str.scan(/first:\s*(.*)\s*last:\s*(.*)\s*/)[0][1] #=> Wall

    # match version
    match = str.match(/first:\s*(.*)\s*last:\s*(.*)\s*/)
    p match[0]
    p match[1] #=> "Larry" # index at 1 because 0 is whole matched string
    p match[2] #=> "Wall"
    p match.captures #=> ["Larry ", "Wall"], same as equivalent to mtch.to_a[1..-1].
    p match.captures[0] #=> "Larry" # lowers index to 0
    p match.captures[1] #=> "Wall"

    # matched with named captures (So much better!)
    match = str.match(/first:\s*(?<first>.*)\s*last:\s*(?<last>.*)\s*/)
    p match[:first]
    p match[:last]

Use %r{} regex form for HTML

    if page =~ %r{<title>(.*?)</title>}m
      puts "Title is #{$1.inspect}"
    end

Previous code from the book, this is my improved example

    if match = page.match(%r{<title>(?<title>.*?)</title>}m)
      puts "Title is #{match[:title].inspect}"
    end


Block comments in ruby

    =begin
    ...
    =end



### Fibers, Threads, and Processes

Fibers are often used to generate values from infinite sequences on demand.
Here’s a fiber that returns successive integers divisible by 2 and not
divisible by 3:

    twos = Fiber.new do 
      num = 2
      loop do
        Fiber.yield(num) unless num % 3 == 0 
        num += 2
      end 
    end
    10.times { print twos.resume, " " }

Because fibers are just objects, you can pass them around, store them in
variables, and so on. 

Fibers can be resumed only in the thread that created them. (unless you
require the fiber lib)


A related but more general mechanism is the continuation. A continuation is a
way of recording the state of your running program (where it is, the current
binding, and so on) and then resuming from that state at some point in the
future. You can use continuations to implement coroutines (and other new
control structures). Continuations have also been used to store the state of a
running web application between requests—a continuation is created when the
application sends a response to the browser; then, when the next request
arrives from that browser, the continuation is invoked, and the application
continues from where it left off. You enable continuations in Ruby by requiring
the continuation library.



### Running multiple processes

The method Object#system executes the given command in a subprocess; it returns
true if the command was found and executed properly. It raises an exception if
the command cannot be found. It returns false if the command ran but returned
an error. In case of failure, you’ll find the subprocess’s exit code in the
global variable $?.

One problem with system is that the command’s output will simply go to the same
destination as your program’s output, which may not be what you want. To
capture the standard output of a subprocess, you can use the backquote
characters, as with `date` in the previous example. Remember that you may need
to use String#chomp to remove the line-ending characters from the result.










<!-- END Pickaxe Part I -->



## Pickaxe Part III Ruby Crystalized

>
Ruby expressions and statements are terminated at the end of a line unless the
parser can determine that the statement is incomplete, such as if the last
token on a line is an operator or comma.

Must be why this works

    mls = "line one\n" + 
          "line two\n"

And this is a syntax error

    mls =   "line one\n"
          + "line two\n"

>    
If Ruby comes across a line anywhere in the source containing just __END__,
with no leading or trailing whitespace, it treats that line as the end of the
program—any subsequent lines will not be treated as program code.

However, these lines can be read into the running pro- gram using the global IO
object DATA

    #!/usr/bin/env ruby

    p DATA.readlines.map(&:chomp)

    __END__
    One
    Two
    Three

prints
    
    ["One", "Two", "Three"]

Every Ruby source file can declare blocks of code to be run as the file is
being loaded (the BEGIN blocks) and after the program has finished executing
(the END blocks):

    BEGIN {

    }

    END {

    }


This I didn't know, you can drop the Q when %Q for a double quotes string
    
    var = 'here'
    puts %Q{var = #{var}} #=> "var = here"
    puts %{var = #{var}} #=> "var = here"


Array of symbols in Ruby 2 is similar to array of strings

    %w{one two three} #=> ["one", "two", "three"]
    %i{one two three} #=> [:one, :two, :three]
    %I{one two three} #=> [:one, :two, :three]

Unlike their lowercase counterparts, %I, %Q, and %W will preform interpolation:

    %I{ one digit#{1+1} three } # => [:one, :digit2, :three]


Regex in sub/gsub using named captures (note that substitution must be in
single quotes or every backslash must be escaped)

    'this that'.sub(/^(?<first>.+)\s(?<second>.+)$/, '\k<second> \k<first>')
    'this that'.sub(/^(?<first>.+)\s(?<second>.+)$/, "\\k<second> \\k<first>")

    # without named captures
    'this that'.sub(/^(.+)\s(.+)$/, '\2 \1')


Class variables belong to the innermost enclosing class or module. Class
variables used at the top level are defined in Object and behave like global
variables. In Ruby 1.9, class variables are supposed to be private to the
defining class, although as the following example shows, there seems to be some
leakage.

    class BugVar
      @@var = 99
      def var
        @@var
      end
    end

    @@var = 100 #=> warning: class variable access from toplevel
    p BugVar.new.var #=> 100


Class variables are inherited by children but propagate upward if first defined
in a child, this is messy.

Pickaxe recommends avoiding class variables.

I'm going to try to avoid class variables now, maybe just use class instance
variables and instance variables.

    class BetterVar

      @var = 99 #<-- class instance var

      class << self         #<-- secret sauce
        attr_accessor :var  #<-- secret sauce
      end

      def var
        self.class.var      #<-- secret sauce
      end

      def var=(x)
        self.class.var = x
      end

    end

    p BetterVar.var #=> 99
    bv = BetterVar.new
    bv.var=200
    p BetterVar.new.var #=> 200
    p BetterVar.var #=> 200


run if the current file is the script being run, can put tests here

    if __FILE__ == $0 
      # tests...
    end



Element reference vs actual method call

    var[] = "one"                   var.[ ]=("one")
    var[1] = "two"                  var.[ ]=(1, "two")
    var["a", /^cat/ ] = "three"     var.[ ]=("a", /^cat/, "three")


If you are writing an [ ]= method that accepts a variable number of indices, it
might be con- venient to define it using this:

    def []=(*indices, value) 
      # ...
    end


#### Ranges in Boolean Expressions (I don't think anybody uses these, and they would baffle anybody reading my code)

    if expr1 .. expr2
    while expr1 .. expr2

A range used in a boolean expression acts as a flip-flop. It has two states,
set and unset, and is initially unset.

1. For the three-dot form of a range, if the flip-flop is unset and expr1 is
   true, the flip-flop becomes set and the the flip-flop returns true.

2. If the flip-flop is set, it will return true. However, if expr2 is not true,
   the flip-flop becomes unset.

3. If the flip-flop is unset, it returns false.

The first step differs for the two-dot form of a range. If the flip-flop is unset and expr1 is true,
then Ruby only sets the flip-flop if expr2 is not also true.

__I've never ever seen this used!__


#### case Expressions

>
Ruby has two forms of case statement. The first allows a series of conditions
to be evaluated, executing code corresponding to the first condition that is
true:

    case
    when something
    ...
    when something_else
    ...
    when yet_something_else
    ...
    else
    ...
    end

Second form takes a target

    case target
    when <test against target>
    ...
    when <test against target>
    ...
    else
    ...
    end

then is optional but good for scrunching down the statement

case target
when <test1> then ...
when <test2> then ...
else ...
end


while and until statements can have a "do"?

until something do
    ...
end

while something do
    ...
end

>
loop, which iterates its associated block, is not a language construct—it is a
method in module Kernel.


while and until modifiers: (not sure if these are a good idea, doesn't look
loopy enough)

    expression while boolean-expression
    expression until boolean-expression

>
break and next may optionally take one or more arguments. If used within a
block, the given argument(s) are returned as the value of the yield. If used
within a while, until, or for loop, the value given to break is returned as the
value of the statement. If break is never called or if it is called with no
value, the loop returns nil. (stop abusing the word yield!, its losing all meaning)

    var = [1,2,3].each do |x|
      break :hello
    end
    var #=> hello

    var = [1,2,3].each do |x|
      break
    end
    var #=> nil

confirmed:

    def my_method 
      yield
    end

    var = my_method do 
      break :there
      :here
    end

    p var #=> :there


>
Outside a class or module definition, a definition with an unadorned method
name is added as a private method to class Object. It may be called in any
context without an explicit receiver.

Confirmed:

    def my_method
    end

    p Object.private_instance_methods.grep /my/ #=> [:my_method]

>
A definition using a method name of the form expr.methodname creates a method
associated with the object that is the value of the expression; the method will
be callable only by sup- plying the object referenced by the expression as a
receiver. This style of definition creates per-object or singleton methods.
You’ll find it most often inside class or module definitions, where the expr is
either self or the name of the class/module. This effectively creates a class
or module method (as opposed to an instance method).

Even works on the default 'main' object

    def self.my_method
    end

    p self.methods.grep /my/ #=> [:my_method]

>
Method definitions may not contain class or module definitions. They may
contain nested instance or singleton method definitions. The internal method is
defined when the enclosing method is executed. The internal method does not act
as a closure in the context of the nested method—it is self-contained.

nested methods aren't scoped to the outer method - use a proc for that

    def my_method
      def my_other_method
        :here
      end
    end

    my_other_method rescue puts $! #=> undefined local variable or method `my_other_method' for main:Object
    my_method
    my_other_method rescue puts $! #=> :here


This is an interesting use of nested methods:

    def clock
      def clock
        puts :tock
      end
      puts :tick
    end

    clock #=> tick
    clock #=> tock

>
A method definition may have zero or more regular arguments, zero or more
keyword arguments, a optional splat argument, an optional double splat
argument, and an optional block argument. Arguments are separated by commas,
and the argument list may be enclosed in parentheses.

This is a little confusing, I wouldn't push my luck with this stuff:

    def mixed(a, b=50, c=b+10, d)
      [ a, b, c, d ]
      end

    p mixed(1, 2)       #=> [1, 50, 60, 2]
    p mixed(1, 2, 3)    #=> [1, 2, 12, 3]
    p mixed(1, 2, 3, 4) #=> [1, 2, 3, 4]


Splats can be in the middle.  This is probably a bad idea

    def splat(first, *middle, last) 
      [ first, middle, last ]
    end
    splat(1, 2)       # => [1, [], 2] 
    splat(1, 2, 3)    # => [1, [2], 3] 
    splat(1, 2, 3, 4) # => [1, [2, 3], 4]


This might be useful

>
If an array argument follows arguments with default values, parameters will
first be used to override the defaults. The remainder will then be used to
populate the array.

    def mixed(a, b=99, *c) 
      [ a, b, c]
    end

    mixed(1)          #=> [1, 99, []]
    mixed(1, 2)       #=> [1, 2, []]
    mixed(1, 2, 3)    #=> [1, 2, [3]]
    mixed(1, 2, 3, 4) # => [1, 2, [3, 4]]

>
Any parameter may be a prefixed with an asterisk. If a starred parameter
supports the to_a method, that method is called, and the resulting array is
expanded inline to provide parameters to the method call. If a starred argument
does not support to_a, it is simply passed through unaltered.

    class MyClass
      def to_a;
        [1,2,3]
      end
    end

    def my_method(*x)
      x.class
    end

    my_method( MyClass.new ) #=> Array

The above paragraph is not quite right.  If the argument doesn't support to_a,
it is not passed through unaltered, but rather in a single element array.



#### Keyword arguments

>
Ruby 2 methods may declare keyword arguments using the syntax name:
default_value for each. These arguments must follow any regular arguments in
the list.

If you call a method that has keyword arguments and do not provide
corresponding values in the method call’s parameter list, the default values
will be used. If you pass keyword parameters that are not defined as arguments,
an error will be raised unless you also define a double splat argument, **arg.
The double splat argument will be set up as a hash containing any uncollected
keyword parameters passed to the method.

    def my_method(x,y, one: :one, two: :two, three: :three)
      p [x,y,one,two,three]
    end

    my_method rescue puts $!           #=> wrong number of arguments (0 for 2)
    my_method(1) rescue puts $!        #=> wrong number of arguments (1 for 2)
    my_method(1,2)                     #=> [1, 2, :one, :two, :three]
    my_method(1,2, one: :a)            #=> [1, 2, :a, :two, :three]
    my_method(1,2, one: :ONE, two: :b) #=> [1, 2, :a, :b, :three]


>
Any parameter may be prefixed with two asterisks (a double splat). Such
parameters are treated as hashes, and their key-value pairs are added as
additional parameters to the method call.

>
Ruby 2 methods may declare keyword arguments using the syntax name:
default_value for each. These arguments must follow any regular arguments in
the list.


keyword arguments with defaults (not required because they have defaults, duh)

    def mymeth1(a:1, b:2, c:3)
    end

    mymeth1(a: 1)


required keyword arguments

    def mymeth2(a:, b:, c:)
    end

    mymeth2(a: 1) rescue puts $! #=> missing keywords: b, c
    mymeth2(a: 1, b: 2, c: 3)


old school default hash for comparison

    def oldmeth(options = {})
      bar = options.fetch(:bar, 'default')
      puts bar
    end

    oldmeth #=> default

old school hash passing, but not so old we needed =>

    oldmeth(bar: 'not_default') #=> not_default


blocks can now how keyword arguments

    define_method(:foo) do |bar: 'default'|
      puts bar
    end

    foo #=> default
    foo(bar: 'baz') # => 'baz'


    define_method(:foo) do |bar:| #<-- required
      puts bar
    end

    foo #=> missing keyword: bar


>
If you call a method that has keyword arguments and do not provide
corresponding values in the method call’s parameter list, the default values
will be used. If you pass keyword parameters that are not defined as arguments,
an error will be raised unless you also define a double splat argument, **arg.
The double splat argument will be set up as a hash containing any uncollected
keyword parameters passed to the method.

    def mymeth(a:, b:, c:, **splat)
      [a,b,c,splat]
    end

    mymeth(x:100,y:101,z:102,a:1,b:2,c:3) #=> [1, 2, 3, {:x=>100, :y=>101, :z=>102}]


undefine methods with undef (not quite sure why)

    undef mymethod
    undef :mymethod

The below paragraph indicates its even more useless.

>
An undefined method still exists; it is simply marked as being undefined. If
you undefine a method in a child class and then call that method on an instance
of that child class, Ruby will immediately raise a NoMethodError—it will not
look for the method in the child’s parents.


Not quite sure why the following happens, but it could be useful if the
passed in method returns a proc

    def my_meth(&block)
    end

    def hello
      puts :hello
    end

    my_meth(&hello) #=> hello


This is a more normal procedure

    def my_meth(&block)
      block.call
    end

    hello = ->{ puts :hello }
    my_meth(&hello) #=> hello


block_given? seems to work also for parameter blocks

    def my_meth(&block)
      block.call if block_given?
    end

    my_meth() #=> no error

>

When a receiver is explicitly specified in a method invocation, it may be
separated from the method name using either a period (.) or two colons (::).
The only difference between these two forms occurs if the method name starts
with an uppercase letter. In this case, Ruby will assume that receiver::Thing
is actually an attempt to access a constant called Thing in the receiver unless
the method invocation has a parameter list between parentheses. Using :: to
indicate a method call is mildly deprecated.

    Foo.Bar()  # method call
    Foo.Bar    # method call
    Foo::Bar() # method call
    Foo::Bar   # constant access

Confirmed;

    class MyClass

      def my_meth
        :hello
      end

      def My_Meth
        :goodbye
      end

    end

    p MyClass.new.my_meth  #=> :hello
    p MyClass.new::my_meth #=> :hello
    p MyClass.new.My_Meth  #=> :goodbye
    p MyClass.new::My_Meth rescue puts $! #=> #<MyClass:0x00000101915be8> is not a class/module


In method aliasing the first param is the _new_ name

    alias new_name name


>
When a method is aliased, the new name refers to a copy of the original method's body. If
the original method is subsequently redefined, the aliased name will still invoke the original
implementation.


Singleton form of class definition, this extends the eigenclass:

    class << obj
      body
    end


_extends() method definition: adds to obj the **instance** methods from each module given as a paremeter_

>
A Ruby class definition creates or __extends__ an object of class Class by executing the code in
body.


##### Playing with extending eigenclass

extending singleton of 'main' object

    class << self
      def my_method
        puts "in my_method"
      end
    end

    my_method #=> "in my_method"

extending some object

    obj = Object.new

    class << obj
      def my_method
        puts 'in obj my_method'
      end
    end

    obj.my_method # "in obj my_method"



extending a class, this proves that class methods are instance methods of a classes eigenclass

    class MyClass
      class << self
        def my_method
          puts "in MyClass my_method"
        end
      end
    end

    MyClass.my_method #=> "in MyClass my_method"


>
Remember that a class definition is executable code. Many of the directives
used in class definitions (such as attr and include) are actually simply
private instance methods of class Module. (note: doesn't have to be private,
see below)


Writing class macro

    class MyBase

      def self.my_macro
        puts :my_macro
      end

    end

    class MyClass < MyBase
      my_macro
    end

    MyClass.new #=> "my_macro"



Overriding class allocation for finer control or to take control over object
initialization. This follows the principal of __most__ surprise, so try to not
do this.

    # normal class definition
    class MyClass
      def self.new
        obj = allocate
        obj.send(:initialize, :hello)
      end
    end

    class MyClass
      def initialize(x)
        puts x
      end
    end

    # class can-opener
    class << MyClass
      def new
        obj = allocate
        obj.send(:initialize, :goodbye)
      end
    end

    MyClass.new #=> "goodbye"


>
A module is basically a class that cannot be instantiated.

>
A module may define an initialize method, which will be called upon the
creation of an object of a class that mixes in the module if either the class
does not define its own initialize method or the class's initialize method
invokes super.

    module MyModule
      def initialize(greeting: 'hello')
        puts greeting
      end
    end

    class MyClass
      include MyModule
    end

    MyClass.new #=> 'hello'
    MyClass.new(greeting:'goodbye') #=> 'goodbye'


>
A module may also be included at the top level, in which case the module's
constants, class variables, and instance methods become available at the top
level.

>
Instance methods defined in modules can be mixed-in to a class using include.
But what if you want to call the instance methods in a module directly?

    module MyModule
      def say_hello()
        puts :hello
      end
    end
    include MyModule # The only way to access MyModule.say_hello
    say_hello #=> hello


    module MyModule
      def say_hello()
        puts :hello
      end
      module_function :say_hello #<-- improvement over include MyModule
    end

    MyModule.say_hello #=> hello


>
module_function: Creates module functions for the named methods. These
functions may be called with the module as a receiver, and also become
available as instance methods to classes that mix in the module. Module
functions are copies of the original, and so may be changed independently. The
instance-method versions are made private. __If used with no arguments,
subsequently defined methods become module functions.__

    module MyModule

      module_function #<-- applies to everything that follows if no arguments

      def say_hello
        puts :hello
      end
      def say_goodbye
        puts :goodbye
      end
    end


    MyModule.say_hello   #=> hello
    MyModule.say_goodbye #=> goodbye

>
The instance method and module method are two different methods: the method
definition is copied by module_function, not aliased.

Rationale for module functions: so you can write a module that have methods
that can both be called Module.method and can be included into classes. Why its
called module_function and not module_method I have no idea.


Access control

- public: accessible to anyone
- protected: Can be invoked only by objects of the defining class and its subs
- private: Can be called only in functional form (with implicit receiver of self)


>
The return value of a yield is the value of the last expression evaluated in
the block or the value passed to a next statement executed in the block.


#### Bock Arguments

- You can specify default values
- You can specify splat arguments
- The last argument can be prefixed with & for a block
- Block local variables are declared after a semi


This gets kinda crazy, not sure if I'd ever use this

    def gimme_a_proc(&block)
      block.call(&->{ puts :here })
    end

    gimme_a_proc() do |&proc|
      proc.call
    end #=> here

#### Proc objects

Four ways to create a proc object

* By passing a block to a method whose last parameter is prefixed with an
ampersand. That parameter will receive the block as a Proc object.

        def meth1(p1, p2, &block) #<-- will run to_proc on block
          puts block.inspect
        end

* By calling Proc.new {}

        block = Proc.new { :hello }

* By calling Object#lambda

        block = lambda { :hello }

* lambda syntax

        lam = ->{ :hello }
        lam = ->(x,y){ puts x,y }

>
Note that there cannot be a space between -> and the opening parenthesis.


>
Here’s the big thing to remember: raw procs are basically designed to work as
the bodies of control structures such as loops. Lambdas are intended to act
like methods. So, lambdas are stricter when checking the parameters passed to
them, and a return in a lambda exits much as it would from a method.

Calling a proc

    proc = Proc.new {}
    proc.call
    proc.()  #<--- cool?
    proc[]
    yield

>
Within both raw procs and lambdas, executing next causes the block to exit back
to the caller of the block. The return value is the value (or values) passed to
next, or nil if no values are passed.    


Dont use - deprecated

    proc = proc {}



#### Exeptions

>
When an exception is raised, Ruby places a reference to the Exception object in
the global variable $!.


Exceptions may be handled in the following ways:

* Within the scope of a begin/end block:

        begin
          ..
        rescue
          ..
        else
          ..
        ensure
          ..
        end


* Within the body of a method:

        begin
          # something which might raise an exception
        rescue SomeExceptionClass => some_variable
          # code that deals with some exception
        rescue SomeOtherException => some_other_variable
          # code that deals with some other exception
        else
          # code that runs only if *no* exception was raised
        ensure
          # ensure that this code always runs, no matter what
        end

* After the execution of a single statement:

        x/y rescue puts $!

>
A rescue clause with no parameter is treated as if it had a parameter of
StandardError


>
If you want to rescue every exception, use this: (note: re-raise this dammit)

    rescue Exception => e



>
The rescue modifier takes no exception parameter and rescues StandardError and
its children.

    values = [ "1", "2.3", /pattern/ ]
    result = values.map {|v| Integer(v) rescue Float(v) rescue String(v) }
    result # => [1, 2.3, "(?-mix:pattern)"]

>
The method Object#catch executes its associated block:

    catch ( object ) do 
      code...
    end

>
The method Object#throw interrupts the normal processing of statements:

    throw( object ‹ , obj › )


My pointless example (not sure if its actually showing throw working)

    val = catch(:outer) do
      catch(:inner) do
        5.times do |x|
          throw(:outer, x) if x==3
        end
      end
    end

    p val #=> 3


>
If the throw is passed a second parameter, that value is returned as the value
of the catch.

>
Ruby honors the ensure clauses of any block expressions it traverses while
looking for a corresponding catch.

>
If no catch block matches the throw, Ruby raises an ArgumentError exception at
the location of the throw.

#### Standard Protocols and Coercions

_from stackoverflow_

* call to_s to get a string that describes the object.
* call to_str to verify that an object really acts like a string.
* implement to_s when you can build a string that describes your object.
* implement to_str when your object can fully behave like a string.

>
As we can see, to_s is happy to turn any object into a string. On the other
hand, to_str raises an error when its parameter does not look like a string.
 
Array#join calls to_str on its param.  If you try a.join(3) it will try to_str
on 3 and raise and exception TypeError: no implicit conversion of Fixnum into
String.  But 3.to_s does have a stringy conversion.  

I guess this is called a protocal because its not really a set of strict rules.



#### The symbol.to_proc trick


    names = %w{ant bee cat}
    result = names.map(&:upcase)



Closer look:

    class MyData

      def initialize(data)
        @data = data
      end

      def yo
        "yo #{@data}"
      end

    end
      
    a = [MyData.new(1), MyData.new(2), MyData.new(3)]
    p a.map(&:yo) #=> ["yo 1", "yo 2", "yo 3"]

    yoproc = :yo.to_proc
    p yoproc.call(MyData.new(1))  #=> "yo 1"


Even closer look, defining our own Symbol#to_proc (this stuff is deep)

    class MyData

      def initialize(data)
        @data = data
      end

      def yo
        "yo #{@data}"
      end

    end
      
    class Symbol
      def to_proc
        print "HERE! "
        proc { |obj, *args| obj.send(self, *args) } #<--- self is :yo
      end
    end

    a = [MyData.new(1), MyData.new(2), MyData.new(3)]
    p a.map(&:yo) #=> HERE! ["yo 1", "yo 2", "yo 3"]

    yoproc = :yo.to_proc
    p yoproc.call(MyData.new(1))  #=> HERE! "yo 1"


Note: inject doesn't seem to need the &

    [1,2,3].inject(&:+) #=> 6
    [1,2,3].inject(:+)  #=> 6


#### Metaprogramming

Accessing class instance variables

    class Test
      @var = 99 
      class << self
        attr_accessor :var
      end 
    end


Object is the superclass of our custom classes.  That's where the free
class methods come from.  Its also where "class macros" come from.  Class
macros and class methods are the same if they are defined one class up.

    class Object
      def hello
        :hello
      end
      def goodbye
        :goodbye
      end
    end

    class MyClass
      print hello
    end

    p MyClass.goodbye #=> hello:goodbye

Access eigenclass of object (not sure why)

animal = 'dog'
singleton = class << animal 
  self 
end
p singleton #=> #<Class:#<String:0x0000010118bcb0>>


>
When you include a module you are effectively adding it as a new superclass.

>
Ruby 2 introduced the __prepend__ method. Logically, this behaves just like
include, but the methods in the prepended module take precedence over those in
the host class. Ruby pulls off this magic by inserting a dummy class in place
of the original host class2 and then inserting the prepended module between the
two.

>
If a method inside a prepended module has the same name as one in the original
class, it will be invoked instead of the original. The prepended method can
then call the original using super.

>
The __include__ method effectively adds a module as a superclass of self. It is
used inside a class definition to make the instance methods in the module
available to instances of the class.  However, it is sometimes useful to add
the instance methods to a particular object. You do this using __extend__

Extending a class is the same as adding instance methods to its eigenclass,
which end up being class methods because instance methods of a classes
eigenclass are that classes class methods.

    module MyModule
      def hello
        :hello
      end
    end

    class MyClass
      include MyModule #<----- include
    end

    p MyClass.new.hello #=> :hello

    Object.send(:remove_const, :MyModule)
    Object.send(:remove_const, :MyClass)

    module MyModule
      def hello
        :hello
      end
    end

    class MyClass
      extend MyModule #<----- extend
    end

    p MyClass.hello #=> :hello


extending an object is the same as extending a class - adding instance methods
to its eigenclass.

    module MyModule
      def hello
        :hello
      end
    end

    obj = Object.new
    obj.extend MyModule

    p obj.hello #=> :hello


simple macro mechanism:

    class MyClass

      def self.my_macro
        def say_hello
          puts :hello
        end
      end

      my_macro

    end

    MyClass.new.say_hello #=> hello

more dynamic macro

    class MySuperClass
      def self.say_macro(word)
        define_method(:say) do
          puts word
        end
      end
    end

    class MyClass < MySuperClass
      say_macro(:goodbye)
    end

    MyClass.new.say #=> goodbye


macro from a module:

    module MyModule
      def say_macro(word) #<-- now a instance method
        define_method(:say) do
          puts word
        end
      end
    end

    class MyClass
      extend MyModule #<-- extend, not include
      say_macro(:goodbye)
    end

    MyClass.new.say #=> goodbye


If you want to add both class and instance methods into a class at once
you can use the __included__ hook:

    module MyModule

      def say_this(this) #<-- instance method
        puts this
      end

      module ClassMethods
        def say_macro(word)
          define_method(:say) do
            puts word
          end
        end
      end

      def self.included(host_class) #<--- hook
        host_class.extend(ClassMethods)
      end

    end

    class MyClass
      include MyModule #<-- include
      say_macro(:goodbye)
    end

    MyClass.new.say_this(:hello) #=> hello
    MyClass.new.say #=> goodbye


#####Subclassing Expressions


The return value of a Struct is a class. which you ordinarily would
use to make objects.

    Person = Struct.new(:name, :address, :likes) #=> Person
    kevin = Person.new('kevin', 'ma') #=> #<struct Person name="kevin", address="ma", likes=nil>

in the class defintion MySuperClass can be any class object

    class MyClass < MySuperClass
    end

    class MyClass < Struct.new(:name, :address, :likes)
      def to_s
        ...
      end
    end



##### Creating single classes

    myclass = Class.new do
      def hello
        :hello
      end
    end

    myclass.new.hello #=> hello


passing argument to Class.new

    myclass = Class.new()
    p myclass.superclass #=> Object

    myclass = Class.new(String)
    p myclass.superclass #=> String

    class MyClass < String
    end
    p MyClass.superclass #=> String


You may have noticed that the classes created by Class.new have no name.
However, if you assign the class object for a class with no name to a constant,
Ruby automatically names the class afterthe constant:

    MyClass = Class.new()
    p MyClass #=> MyClass

We can use these dynamically constructed classes to extend Ruby in interesting
ways. For example, here's a simple reimplementation of the Ruby Struct class:

    def MyStruct(*keys)
    Class.new do
      attr_accessor *keys
        def initialize(hash)
          hash.each do |key, value|
            instance_variable_set("@#{key}", value)
          end
        end
      end
    end

    Person = MyStruct :name, :address, :likes
    dave = Person.new(name: "dave", address: "TX", likes: "Stilton")

The methods Object#__instance_eval__, Module#__class_eval__, and
Module#__module_eval__ let you set self to be some arbitrary object, evaluate
the code in a block with, and then reset self:

    'dog'.instance_eval do
      puts self.upcase #=> DOG
      puts upcase      #=> DOG
    end

    class MyClass
      def self.hello
        puts :hello
      end
    end

    MyClass.class_eval do
      hello
    end

>
Both forms also take a string, but this is considered a little dangerous.


> 
__class_eval__ and __instance_eval__ both set self for the duration of the
block. However, they differ in the way they set up the environment for method
definition. __class_eval__ sets things up as if you were in the body of a class
definition, so method definitions will define instance methods.  In contrast,
calling __instance_eval__ on a class acts as if you were working inside the
singleton class of self. Therefore, any methods you define will become class
methods.


    MyClass = Class.new

    MyClass.class_eval do
      def hello
        puts :hello
      end
    end

    MyClass.new.hello #=> hello

    MyClass.instance_eval do
      def goodbye
        puts :goodbye
      end
    end

    MyClass.goodbye #=> goodbye

> 
Ruby has variants of these methods. Object#__instance_exec__,
Module#__class_exec__, and Module#__module_exec__ behave identically to their
_eval counterparts but take only a block (that is, they do not take a string).
Any arguments given to the methods are passed in as block parameters.  This is
an important feature.  Previously it was impossible to pass an instance
variable into a block given to one of the _eval methods - because self is
changed by the call, these variables go out of scope.

    'cat'.instance_exec('dog') do |animal|
      puts upcase         #=> CAT
      puts animal.upcase  #=> DOG
    end

__Yikes__

>
Ruby 1.9 changed the way Ruby looks up constants when executing a block using
__instance_eval__ and __class_eval__. Ruby 1.9.2 then reverted the change. In
Ruby 1.8 and Ruby 1.9.2, constants are looked up in the lexical scope in which
they were referenced. In Ruby 1.9.0, they are looked up in the scope in which
instance_eval is called. This (artificial) example shows the behavior at the
time I last built this book - it may well have changed again by the time you
run it....

#### instance_eval and domain-specfic languages

    class Conversation

      def start(&b)
        instance_eval(&b) #<-- secret sauce
      end

      def hello
        puts :hello
      end

      def goodbye
        puts :goodbye
      end

    end

    Conversation.new.start do
      hello   #=> hello
      goodbye #=> goodbye
    end 


>
There’s a drawback, though. Inside the block, scope isn’t what you think it is,
so this code wouldn’t work:

    @size = 4 
    turtle.walk do
      4.times do 
        turtle.forward(@size) 
        turtle.left
      end 
    end

>
Instance variables are looked up in self, and self in the block isn’t the same
as self in the code that sets the instance variable @size. Because of this,
most people are moving away from this style of instance_evaled block.


##### Hook methods

Method related

    method_added 
    method_missing 
    method_removed
    method_undefined
    singleton_method_added 
    singleton_method_removed
    singleton_method_undefined

Class and module related

    append_features 
    const_missing 
    extend_object 
    extended 
    included 
    inherited 
    initialize_clone 
    initialize_copy 
    initialize_dup

#### inherited hook

    class MyClassBase
      def self.inherited(child)
        p child
      end
    end

    class MyClassA < MyClassBase
    end #=> MyClassA

    MyClassC = Class.new(MyClassBase) #=> #<Class:0x0000010118b260>


#### method_missing Hook

>
The built-in method_missing basically raises an exception (either a
NoMethodError or a NameError depending on the circumstances).  The key here is
that method_missing is simply a Ruby method. We can override it in our own
classes to handle calls to otherwise undefined methods in an
application-specific way.

>
method_missing has a simple signature, but many people get it wrong:

    def method_missing(name, *args, &block)

>
Before we get too deep into the details, I’ll offer a tip about etiquette.
There are two main ways that people use method_missing. The first intercepts
every use of an undefined method and handles it. The second is more subtle; it
intercepts all calls but handles only some of them. In the latter case, it is
important to forward on the call to a superclass if you decide not to handle it
in your method_missing implementation:

    class MyClass < OtherClass
      def method_missing(name, *args, &block)
        if <some condition> # handle call
        else
          super # otherwise pass it on
        end 
      end
    end


Object is the superclass of normal class defintion

    class MyClassA #<--- default 'Object'
    end

    class MyClassB < Object
    end

    p MyClassA.superclass
    p MyClassB.superclass


#### Looking Inside Classes

false argument in the following classes will prevent recurse into parent
classes

    Demo = Class.new
    Demo.private_instance_methods(false)
    Demo.protected_instance_methods(false)
    Demo.public_instance_methods(false)
    Demo.singleton_methods(false)
    Demo.class_variables
    Demo.constants(false)

    demo = Demo.new
    demo.instance_variables
    demo.public_method

#### Calling methods dynamically


Object#send:

    'cat'.send(:length) #=> 3
    'cat'.send(:upcase) #=> CAT

Method Objects

    cl = 'cat'.method(:length)
    p cl #=> #<Method: String#length>
    p cl.call #=>3

    cl = 'cat'.method(:[])
    p cl #=> #<Method: String#[]> 
    p cl[1] #=> a

Another example

    def plus1(x)
      x += 1
    end

    meth_obj = method(:plus1)

    p meth_obj.to_proc #=> #<Proc:0x0000010190fbf8 (lambda)> lambda!

    p [1,2,3].map(&meth_obj) #=> [2,3,4]


Method objects are bound to one particular object. You can create unbound
methods (of class UnboundMethod) and then subsequently bind them to one or more
objects. The binding creates a new Method object. As with aliases, unbound
methods are references to the definition of the method at the time they are
created.  (Note: this seems very restrictive and useless)

    class MyClass
      def hello; p hello end
    end

    meth = MyClass.instance_method(:hello)
    some_random_obj = Object.new
    meth.bind(some_random_obj)
    some_random_obj.hello #=> bind argument must be an instance of MyClass


#### Hooking method calls

Old method with alias_method

    class Object

      alias_method :old_puts, :puts

      def puts(*args)
        old_puts "About to puts something..."
        old_puts(*args)
      end

    end

    puts :hello

New method with __prepend__

    module MyStuff
      def puts(*args)
        print "... "
        super
      end
    end

    class Object
      prepend MyStuff
    end

    puts :hello #=> "... hello"

Another (ridiculous) way to hook a method - using unbound methods of course

    class MyClass
      def goodbye
        puts :goodbye
      end
    end

    class MyClass

      old_method = instance_method :goodbye

      # redefine goodbye to say hello first
      define_method :goodbye do
        print 'hello '
        old_method.bind(self).call
      end

    end

    MyClass.new.goodbye #=> hello goodbye


Print current file:

    print File.read(__FILE__)


Finished -  now I'm going to forget all the above.




## The Well Grounded Rubyist

### Part 1 - Ruby Foundations

_Moving on_

### Part 2 - Built-in classes and modules

>
Ruby has a lot of built-in classes. Most of them can be instantiated using new:

    str = String.new
    arr = Array.new


>
Some can’t; for example, you can’t create a new instance of the class
__Integer__.  But for the most part, you can create new instances of the
built-in classes.

>
In addition, a lucky, select few built-in classes enjoy the privilege of having
__literal__ constructors. That means you can use special notation, instead of a
call to new, to create a new object of that class.

    String      'new string'
    Symbol       :symbol
    Array        [1,2,3]
    Hash         {:one => 1}
    Range        0..9 or 0...10
    Regexp       /.*/
    Proc         ->(x,y){ x * y }



By defining + you get += for free

    class MyInt

      def initialize(int)
        @int = int
      end

      def +(other)
        @int + other
      end

    end

    int = MyInt.new(1)

    p int + 1 #=> 2

    int += 1
    p int     #=> 2



_Section is about defining sugar, but don't forget Forwardable can make this easier:_

    require 'forwardable'
    class MyInt

      extend Forwardable
      def_delegators :@int, :to_s, :+

      def initialize(str)
        @int = str
      end

    end

    int = MyInt.new(1)

    p int
    p int.to_s #=> "1"
    p int + 1 #=> 2



Don't forget, too, the conditional assignment operator **||=**, as well as its
rarely spotted cousin **&&=** , both of which provide the same kind of shortcut
as the pseudooperator methods but are based on operators, namely **||** and
**&&** , which you can't override.


Rare &&= : assigns value only if target is 'true'

    var = 1
    var &&= 2 # same as next line
    # var = var && 2 
    p var #=> 2

    var = nil
    var &&= 2 # same as next line
    # var = var && 2
    p var #=> nil


Defining unary operator

    class MyClass
      def +@ # <--- weird but right
        :+
      end

      def -@ # <--- weird but right
        :-
      end
    end

    a = MyClass.new
    p +a #=> :+

    b = MyClass.new
    p -b #=> :-


There's an overridable ! method, huh

    class MyClass

      def !
        'calling !'
      end

    end

    o = MyClass.new
    p !o #=> 'calling !'
    p (not o) #=> 'calling !' 


I wonder how the following happens

>
When it comes to generating string representations of their instances, some
built-in classes do things a little differently from the defaults. For example,
if you call puts on an array, you get a cyclical representation based on
calling to_s on each of the elements in the array and outputting one per line.
That is a special behavior; it doesn't correspond to what you get when you call
to_s on an array, namely a string representation of the array in square
brackets, as an array literal. 

>
You’ve already seen the star operator used in method parameter lists, where it
denotes a parameter that sponges up the optional arguments into an array. In
the more general case, the star turns any array, or any object that responds to
to_a, into the equivalent of a bare list.

>
The term bare list means several identifiers or literal objects separated by
commas. Bare lists are valid syntax only in certain contexts. For example, you
can put a bare list inside the literal array constructor brackets:

  [1,2,3,4,5]

>
**It’s a subtle distinction, but the notation lying between the brackets isn’t,
itself, an array; it’s a list, and the array is constructed from the list,
thanks to the brackets.**


All these work the same, assinging x=1, y=2, z=3

    x,y,z = 1,2,3
    puts x,y,z

    x=y=z = nil

    x,y,z = [1,2,3]
    puts x,y,z

    x=y=z = nil

    x,y,z = *[1,2,3]
    puts x,y,z

>
The star has a kind of bracket-removing or un-arraying effect. What starts as
an array becomes a list.


Use to_s for display purposes, use to_str if you want your object to be a
string.

    obj + "there." #=> "Hello there." (uses to_str)

    obj << " that" #=> "this that" (uses to_str)


to_str is required for the following to work (to_s) didn't do it

    class MyClass

      def initialize(data)
        @data = data
      end
      
      def to_str
        @data.to_s 
      end

    end

    p "my string " + MyClass.new([1,2,3]) #=> "my string [1, 2, 3]"


>
Objects can masquerade as arrays if they have a to_ary method. If such a method
is present, it’s called on the object in cases where an array, and only an
array, will do— for example, in an array-concatenation operation.

    [1,2,3].concat(my_obj)

>
If you define ==, your objects will automatically have the != method.

>
But for classes that do need full comparison functionality, Ruby provides a
convenient way to get it. If you want objects of class MyClass to have the full
suite of comparison methods, all you have to do is the following:
>

>
1. Mix a module called Comparable (which comes with Ruby) into MyClass.
2. Define a comparison method with the name <=> as an instance method in
MyClass.

    class MyInt

      attr_accessor :int

      def initialize(int)
        self.int = int
      end

    end


    one = MyInt.new 1
    two = MyInt.new 1

    p one == two #=> false

    # reopen class
    class MyInt

      include Comparable

      def <=>(other)
        self.int <=> other.int
      end

    end

    one = MyInt.new 1
    two = MyInt.new 1

    p one == two #=> true


method reflection method grouping (to help remembering)

    MyClass.methods #<-- class methods

    MyClass.instance_methods #<-- instance methods defined in class
    MyClass.public_instance_methods
    MyClass.private_instance_methods
    MyClass.protected_instance_methods


    obj.methods #<-- instance methods
    obj.private_methods    
    obj.public_methods
    obj.protected_methods
    obj.singleton_methods

    MyClass.new.methods == MyClass.instance_methods
    MyClass.instance_methods == MyClass.public_instance_methods


Extract a string with [] (also known as slice)

    "my string"[3, 100] #=> "string" (second arg is length, not position)
    "my string"[3..-1] #=> "string" use a range if you have two positions

Test for substring without a regex 

    p "my string"['string'] #=> 'string' # finds and returns a substring
    p "my string"['no string'] #=> nil

    target = 'str'
    if 'my string'[target]
      puts "found target #{target}"
    end

The regex option

    target = /str/
    if 'my string'[target]
      puts "found target #{target}" #+> found target (?-mix:str)
    end

Above better than this? (maybe because I always type =~ wrong)

    target = /str/
    if 'my string' =~ target
      puts "found target #{target}" #+> found target (?-mix:str)
    end

One more

    target = /str/
    if 'my string'.match(target)
      puts "found target #{target}" #+> found target (?-mix:str)
    end


Found another one

    target = 'str'
    if 'my string'.include? target
      puts "found target #{target}"
    end


slice has a bang!

    str = 'my string'
    p str.slice!('my ') #=> 'my '
    p str #=> "string"

>
To set part of a string to a new value, you use the []= method. Or just use
sub!/gsub!

    str = 'my string'
    str['my'] = 'not my'
    p str #=> 'not my string'

    str = 'my string'
    str.sub!('my', 'not my')
    p str #=> 'not my string'

Count the letters in a string

    'this is my string'.count('i') #=> 3
    'this is my string'.count('a-z') #=> character range

>
Consider allowing symbols or strings as method arguments
When you’re writing a method that will take an argument that could conceivably
be a string or a symbol, it’s often nice to allow both. It’s not necessary in
cases where you’re dealing with user-generated, arbitrary strings, or where
text read in from a file is involved; those won’t be in symbol form anyway. But
if you have a method that expects, say, a method name, or perhaps a value from
a finite table of tags or labels, it’s polite to allow strings or symbols. That
means avoiding doing anything to the object that requires it to be one or the
other and that will cause an error if it’s the wrong one. You can normalize the
argument with a call to to_sym (or to_s, if you want to normalize to strings)
so that whatever gets passed in fits into the operations you need to perform.


Weird parens when using hash.each_with_index

    a.each_with_index {|(k,v), i| p k,v,i }

Spliltting also works with procs but not lambdas because theres no || in lambdas

    p = Proc.new {|(x,y)| puts "first:#{x} second:#{y}" }
    p.call([1,2]) #=> first:1 second:2

    l = lambda { |(a,b)| puts "first:#{a} second:#{b}" }
    l.call([1,2])

Doesn't work with arrow lambda syntax because there's no | |

    l = ->(x){ puts "first:#{?} second:#{?}" }
    l.call([1,2])

_Hash to array intermission_

    h = Hash[*[1,2,3,4]]  

    # note, this is how you construct a hash with keys and values, not Hash.new(a:1, b:2)
    h = Hash[a:1, b:2]

    # new() is for defaults
    h2 = Hash.new(99)
    h2[:one] #=> 99

Array constructor can take a block (note the 3)

    x = 1
    a = Array.new(3) do
      x *= 10
    end

    p a #=> [10, 100, 1000]



_hash intermission (note, Hash() is a method), Hash[] and Hash() are the same_

    p Hash(a:1, b:2, c:3) #=> {:a=>1, :b=>2, :c=>3}
    p Hash[a:1, b:2, c:3] #=> {:a=>1, :b=>2, :c=>3}


[]= and Array() method

    class Arrayish

      def initialize(a)
        @a = a
      end

      def []=(index, value)
        @a[index] = value
      end

      def to_a
        @a
      end

    end

    a = Arrayish.new(%i{a b c})
    a[3] = :d # because we implemented []=
    p a.class #=> Arrayish
    real_array = Array(a) # because we implemented to_a
    p real_array.class #=> Array


To make slices work you need to build []= like this

    def []=(*index, value)
      @a[*index] = value
    end

    a = Arrayish.new(%i{a b c})
    a[0,2]  = :x, :y
    p a.to_a #=> [:x, :y, :c]

Array#push can take multiple values, Array#<< can't

    a = %i{ one two three}
    a << [:four, :five]
    p a #=> [:one, :two, :three, [:four], [:five]]

    a = %i{ one two three}
    a.push *[:four, :five] #=> note the splat
    p a #=> [:one, :two, :three, :four, :five]

Array#pop can take a number argument

    a = %i{ one two three}
    p a.pop(2) #=> [:two, :three]
    p a        #=> :one

Array#flatten can take level argument - there's also a flatten!

    array = [1,2,[3,4,[5],[6,[7,8]]]]
    array.flatten(2) #=> [1, 2, 3, 4, 5, 6, [7, 8]]      

You can uniq arrays - also uniq!

    [1,2,3,1,4,3,5,1].uniq #=> [1, 2, 3, 4, 5] 


Array#compact removes nils from arrays (not false)

    [1, nil, 2, nil, 3].compact #=> [1,2,3]


Three ways to create a Hash

    {one:1, two:2, three:3}
    Hash.new(:default)
    Hash[:one, 1, :two, 2, :three, 3] #<-- takes a 'list'


Hash#store takes two arguments

    hash = {}
    hash.store(:one, 1) #<-- list
    hash.store(*[:two, 2]) #<-- splat array
    hash.store( *'three 3'.split ) #<-- really grasping
    p hash #=> {:one=>1, :two=>2, "three"=>"3"}


My attempt to unique values of hash elegantly

    h = {a:1, b:2, c:3, d:1, e:2}
    h = h.invert.invert
    p h #=> {:d=>1, :e=>2, :c=>3}


My attempt to sort hash by values

    h = {a:1, b:2, c:3, d:1, e:2}
    h = h.sort { |a,b| a[1] <=> b[1] } #--> there is no Hash#sort!
    p Hash[*h.flatten] #=> {:a=>1, :d=>1, :b=>2, :e=>2, :c=>3} 

breaking news... there's a __sort_by__ and a __to_h__, use _k for unused block param

    hash = {a:1, b:2, c:3, d:1, e:2}
    hash = hash.sort_by { |_k,v| v }.to_h
    p hash #=> {:a=>1, :d=>1, :b=>2, :e=>2, :c=>3} 

Waring Array#to_h is weird

    [:one, 1, :two, 2, :three, 3].to_h #=> wrong element type Symbol at 0 (expected array) 

    [[:one, 1], [:two, 2], [:three, 3]].to_h #=> {:one=>1, :two=>2, :three=>3}

To change array into hash in one line, use each_slice, enumerator.to_a

    [:one, 1, :two, 2, :three,3].each_slice(2).to_h


Hash#fetch is versitile

    h = {one: 1, two: 2, three: 3}

    p h.fetch(:three) #=> 3
    p h.fetch(:four, 4) #=> 4
    h.fetch(:four) rescue p $! #=> key not found: :four (KeyError) 
    h.fetch(:four) {|k| p "sorry no #{k}" } #=> sorry no four

Hash#values_at is similar to Array#values_at

    h = {one: 1, two: 2, three: 3}

    p h.values_at(:one, :three) #=> [1,3]


Hash constructor takes a default value

    h = Hash.new(0)
    h[:nope] #=> 0

Hash constructor can autovivify

    h = Hash.new {|hash,key| hash[key] = 0 }

    h.store(:one,1)
    p h #=> {:one => 1}

    h[:two] #=> 0
    p h #=> {:one => 1, :two => 2} 



#### Ranges

Ranges are enclusive or exclusive

    (1..10).include?  10 #=> true
    (1...10).include? 10 #=> false

_Think of ... as pushing the last value outside the range_

Ranges and __include?__ and __cover?__, cover? is simplier and faster, won't
use with strings because its confusing.  Note that cover? is exclusive to
ranges 

    p ('a'..'c').cover? 'abc' #=> true
    p ('a'..'c').include? 'abc' #=> false

    p ('a'..'c').cover? 'bcd' #=> true
    p ('a'..'c').include? 'bcd' #=> false

    p ('a'..'c').cover? 'cde' #=> false
    p ('a'..'c').include? 'cde' #=> false


This test is useless

    [1,2,3,nil,4,5,6].find {|n| n.nil? }

This could work

    [1,2,3,nil,4,5,6].find_all {|n| n.nil? }.count > 0

This doesn't because [nil].any? is false

    [1,2,3,nil,4,5,6].find_all {|n| n.nil? }.any?

Enumerable#grip operates on === and works like:

    enumerable.select {|element| expression === element }

Enumerable#group_by is cool

    colors = %w{ red orange yellow blue indigo violet }

    colors.group_by{|c| c[0]} #=> {"r"=>["red"], "o"=>["orange"], "y"=>["yellow"], "b"=>["blue"], "i"=>["indigo"], "v"=>["violet"]}

    colors.group_by{|c| c.size} #=> {3=>["red"], 6=>["orange", "yellow", "indigo", "violet"], 4=>["blue"]}

Enumerable#partition is also cool

    a = [1,2,3,4,5,6]
    p a.partition {|x| (1..3).cover?(x)} #=> [[1, 2, 3], [4, 5, 6]] 

Enumerable#take and Enumerable#drop are complementary (neither alters original array)
drop is like an undestructive pop and take is like an undestructive shift

    a = [1,2,3,4,5,6]
    a.drop(2) #=> [3, 4, 5, 6]
    a         #=> [1, 2, 3, 4, 5, 6]
    a.pop(4)  #=> [3, 4, 5, 6]
    a         #=> [1, 2]

    a = [1,2,3,4,5,6]
    a.take(2)  #=> [1,2]
    a          #=> [1, 2, 3, 4, 5, 6]
    a.shift(2) #=> [1,2]
    a          #=> [3, 4, 5, 6]


Constrain Enumerable#take and Enumerable#drop with take_while and drop_while

    [1,2,3,4,5,6].take_while {|x| x < 4 } #=> [1,2,3]


loop catches StopIteration exception, so yo can use it like this 

    e = [1,2,3,4,5,6].each_slice(2)

    loop do
      p e.next
    end


which looks more pro?

    e.inject([]){|acc, x| acc << x; acc} 
    e.reduce([]){|acc, x| acc << x; acc} 

fancy map in place

    names = %w{ David Yukihiro Chad Amy }
    names.map!(&:upcase)

>
Even though Ruby strings aren’t enumerable in the technical sense (String does
not include Enumerable), the language thus provides you with the necessary
tools to address them as character, byte, codepoint, and/or line collections
when you need to.

>
Sorting enumerables: If you have a class, and you want to be able to arrange
multiple instances of it in order, you need to do the following:
  1. Define a comparison method for the class (<=>).
  2. Place the multiple instances in a container, probably an array.
  3. Sort the container.

    class MyClass

      attr_accessor :var

      def initialize(x)
        self.var = x
      end

      def <=>(other)
        self.var <=> other.var
      end

    end

    collection = [5,1,3,4,2].map {|x| MyClass.new(x)}
    collection.sort.map {|c| c.var} #=> [1,2,3,4,5]


>
Comparable, enumerables and <=>:
* If you define <=> for a class, then instances of that class can be put inside
an array or other enumerable for sorting.
* If you don’t define <=>, you can still sort objects if you put them inside an
  array and provide a code block telling the array how it should rank any two
of the objects. 
* If you define <=> and also include Comparable in your class, then you get
   sortability inside an array and you can perform all the comparison
operations between any two of your objects (>, <, and so on)



Poor mans sorting (class doesn't have <=> method)

    class MyClass

      attr_accessor :var

      def initialize(x)
        self.var = x
      end

    end

    collection = [5,1,3,4,2].map {|x| MyClass.new(x)}
    collection.sort{|a,b| a.var <=> b.var }.map {|c| c.var} #=> [1,2,3,4,5]


Enumerable#sort_by makes it even cleaner

    class MyClass

      attr_accessor :var

      def initialize(x)
        self.var = x
      end

    end

    collection = [5,1,3,4,2].map {|x| MyClass.new(x)}
    collection.sort_by{|x| x.var }.map {|c| c.var} #=> [1,2,3,4,5]

    # even shorter!
    collection.sort_by(&:var).map {|c| c.var} #=> [1,2,3,4,5]


### Enumerators

>
At heart, an enumerator is a simple enumerable object. It has an each method,
and it **employs the Enumerable module** to define all the usual methods—select,
inject, map, and friends—directly on top of its each.

>
An enumerator isn’t a container object. It has no “natural” basis for an each
operation, the way an array does (start at element 0; yield it; go to element
1; yield it; and so on). The each iteration logic of every enumerator has to be
explicitly specified. **After you’ve told it how to do each, the enumerator
takes over from there and figures out how to do map, find, take, drop, and all
the rest.**



Simple enumerator with new

    e = Enumerator.new do |y|
      y.yield :a #<-- each call and stop
      y.yield :b #<-- each call and stop
      y.yield :c #<-- each call and stop
    end


    loop do
      p e.next
    end


Same

    Object#to_enum
    Object#to_enum(:each)




From a blog:  How to make your class return an enumerator instead of including Enumerable

    class UsersWithGravatar
      def each

        return enum_for(:each) unless block_given? # Sparkling magic!

        User.find_each do |user|
          hash  = Digest::MD5.hexdigest(user.email)
          image = "http://www.gravatar.com/avatar/#{hash}"
          yield user unless Net::HTTP.get_response(URI.parse(image)).body == missing_avatar
        end
      end
    end


proof that to_enum hooks up to each

    o = Object.new

    def o.each
      print 'running each '
      yield 1
      yield 2
      yield 3
    end

e = o.to_enum
p e.next #=> "running each 1"



My example of implementing an enumerator for MyClass without cheating with an existing each()

    class MyClass

      attr_accessor :data

      def initialize(data)
        self.data = data
      end

      def each(&block)
        for x in self.data #<-- no state needed here, uses fibers behind the scene
          block.call(x) 
        end
      end

      def to_enum
        Enumerator.new do |y|
          each do |x| #<-- our implemented each
            y << x #<-- blocks after each next
          end
        end
      end

    end

    o = MyClass.new([:a,:b,:c])
    e = o.to_enum

    p e.map.with_index {|x, i| [x,i]}.to_h #=> {:a=>0, :b=>1, :c=>2}


Enumerators really aren't tied to each.  It just happens that the to_enum
method of most classes will default to using each, enumerators aren't dependent
on any particular method to work.

    a = [1,2,3,4,5]
    e = Enumerator.new do |y|
      total = 0
      until a.empty?
        total += a.pop
        y << total
      end
    end

    loop do 
      print e.next #=> 5912141
    end

An enumerator just needs something to feed to <<

    e = Enumerator.new do |y|
      loop do
        y << Time.now
      end
    end

    e.first(3) #=> [2015-02-19 18:51:13 -0500, 2015-02-19 18:51:13 -0500, 2015-02-19 18:51:13 -0500]
 

>
An enumerator is an object, and can therefore maintain state. It remembers
where it is in the enumeration. An iterator is a method. When you call it, the
call is atomic; the entire call happens, and then it’s over.


My example of how to implement to_enum that takes a method parameter

    class MyClass

      attr_accessor :data

      def initialize(data)
        self.data = data
      end

      def to_enum(method)
        Enumerator.new do |y|
          self.send(method) do |x| #<-- special sauce
            y << x
          end
        end
      end

      def myeach(&b)
        for i in data
          b.call(i)
        end
      end

    end

    o = MyClass.new(%i{one two three four five})
    e = o.to_enum(:myeach)

    loop do
      p e.next
    end



### Regex


_I'm leaning to accept that the below are only good for their bool value (as a
more rubyish replacement for =~) and are otherwise not very useful **without
captures** - nobody cares about prematch or postmatch, etc._

    regex.match(string)
    string.match(regex)

    str.match(/(my)/) #=> #<MatchData "my" 1:"my">
    str.match(/not my/) #=> nil
    str.match(/(my)/).begin(0) #=> 8
    str.match(/(my)/).to_a #=> ['my', 'my'] [whole string, captures...]
    str.match(/(my)/).pre_match #=> 'this is '
    str.match(/(my)/).post_match #=> ' string'

With captures

    str.match(/my/)[0] #=> my
    str.match(/my/)[1] #=> nil, whoops forgot to capture
    str.match(/(my)/)[1] #=> my

Two ways to get at captures.  I like the second if there's room because it doesn't have the indexing confusion

    str.match(/(my)/)[1] #=> my
    str.match(/(my)/).captures(0) #=> my

    m[1] == m.captures[0]
    m[2] == m.captures[1]


>
Anything inside a (?:) grouping will be matched based on the grouping, but not
saved to a capture. 

Escaping regex

    search_for = 'a.c'
    re = /#{Regexp.escape(str)}/ #=>  /a\.c/
    re.match("a.c") #=>  #<MatchData "a.c">
    re.match("abc") #=> nil, because '.' is not /./


'Zero or one' is slightly unintuitive to me when used like this

    ''.match(/(.?)/)[1] #=> ""

But I've often used it like this:

    'name: kevin'.match(/name:? (.*)/)[1] #=> 'kevin'

Don't forget ignores match (bad exaple)

    'one two three'.match(/(\w*) (?:\w*) (\w*)/).captures

>
Regular expressions, it should be noted, can't do everything. In particular,
it's a commonplace and correct observation that you can't parse arbitrary XML
with regular expressions, for reasons having to do with nesting of elements and
the ways in which character data are represented. 


String#scan is great

     "testing 1 2 3 testing 4 5 6".scan(/\d/) 
     #=> ["1", "2", "3", "4", "5", "6"]

    'one two three'.scan(/\w+/) 
    #=> ["one", "two", "three"]

>
If you use parenthetical groupings in the regexp you give to scan, the
operation returns an array of arrays. Each inner array contains the results of
**one scan** through the string:

    # without
    "first:Kevin last:Swope first:Bob last:Smith".scan(/first:\w+ last:\w+/) 
    #=> ["first:Kevin last:Swope", "first:Bob last:Smith"]

    # with
    "first:Kevin last:Swope first:Bob last:Smith".scan(/first:(\w+) last:(\w+)/) 
    #=> [["Kevin", "Swope"], ["Bob", "Smith"]]


    "first:Kevin last:Swope first:Bob last:Smith".scan(/first:(\w+) last:(\w+)/).each do |(f,l)|
      p "#{f} => #{l}"
    end
    
    "Kevin => Swope"
    "Bob => Smith"

    # don't need an each, scan takes a block and knows what to do

    "first:Kevin last:Swope first:Bob last:Smith".scan(/first:(\w+) last:(\w+)/) do |(f,l)|
      p "#{f} => #{l}"
    end

>
Note that if you provide a block, scan doesn't store the results up in an array
and return them; it sends each result to the block and then discards it. That
way, you can scan through long strings, doing something with the results along
the way, and avoid using up a lot of memory-saving substrings you've already
seen and used.

>
Using the notion of a pointer into the string, StringScanner lets you traverse
across the string as well as examine what's already been matched and what
remains. StringScanner is a useful complement to the built-in string scanning
facilities.

>
Enumerable#grep does a filtering operation from an enumerable object based on
the case equality operator (===), returning all the elements in the enumerable
that return a true value when threequaled against grep's argument. Thus if the
argument to grep is a regexp, the selection is based on pattern matches, as per
the behavior of Regexp#===:

### Part 3 - Ruby Dynamics

Class methods are just instance methods defined on a classes eigenclass:

    MyClass = Class.new

    # define class method "outside" class
    def MyClass.hello
      p :hello
    end

    # define class method "inside" class
    class MyClass
      def self.goodbye
        p :goodbye
      end
    end

    MyClass.hello   #=> :hello
    MyClass.goodbye #=> :goodbye

But to get inside the definition body of a singleton class, you use a special notation:

    class << object
     # method and constant definitions here
    end


Example:

    class MyClass
      class << self

        attr_accessor :var #<-- access to class instance var

        def mymethod #<-- class method
        end

      end
    end

>
The << object notation means the anonymous, singleton class of object. When
you're inside the singleton class definition body, you can define methods - and
these methods will be singleton methods of the object whose singleton class
you're in. 


Comparing class and instance variables inside eigenclass


    MyClass = Class.new

    class << MyClass
      def hello
        p :hello
      end
    end

    MyClass.hello #=> :hello


    obj = Object.new

    class << obj
      def hello
        p :hello
      end
    end

    obj.hello #=> :hello



class keyword either accepts a constant or a << object:

    class MyClass
      #...
    end

    class << myobj
      #...
    end

Most common use of class << is to open a classes eigenclass to create class methods, for those
too lazy to type def self.method

    class MyClass
      class << self
        def mymethod
      end
    end


Mixing a module into an objects eigenclass puts the modules method in front of
the classes instance method, which seems to be the same effect as prepend()

    class MyClass
      def hello
        p :hello
      end
    end

    o = MyClass.new
    o.hello #=> :hello

    module MyModule
      def hello
        p :goodbye
      end
    end

    class << o
      include MyModule
    end

    o.hello #=> :goodbye

>
Almost every object in Ruby can have methods added to it. The exceptions are
instances of certain Numeric subclasses, including integer classes and floats,
and symbols. 


Class methods are eigenclass methods but there's a lookup chain, unlike an
objects eigenclass methods.

    class C
      def self.hello
        p :hello
      end
    end

    class D < C
    end

D.hello #=> :hello

>
Singleton classes of class objects are sometimes called metaclasses


>
Kernel#extend - Adds to obj the instance methods from each module given as a
parameter.

    module MyModule
      def hello
        p :hello
      end
    end

    class MyClass
    end

    MyClass.extend(MyModule) # adds to eigenclass of class
    MyClass.hello #=> :hello

    o = Object.new
    o.extend(MyModule) # adds to eigenclass of object
    o.hello #=> :hello

_Looks like extend is include that targets the eigenclass_


Using extend to modify a single object in a convenient way

    module HashWithLogging
      def []=(key, value)
        puts "Assigning #{value} to #{key}"
        super
      end
    end

    hash = {}
    hash.extend(HashWithLogging)
    hash[:one] = 1 #=> Assigning 1 to :one

This does the same but looks terrible

    module HashWithLogging
      def []=(key, value)
        puts "Assigning #{value} to #{key}"
        super
      end
    end

    hash = {}

    class << hash
      include HashWithLogging
    end

    hash[:one] = 1 #=> Assigning 1 to :one

In other code, these two are the same

    hash.extend(HashWithLogging)

    class << hash
      include HashWithLogging
    end


_Side note, I'm thinking that alias_method exists only to create decorators for
methods.  Its a way to **redefine** a method (not override in a subclass)
without losing it.  The only reason to do that is to impersonate the existing
method and wrap it._


#### BasicObject

    obj.class.ancestors.last == BasicObject

_Moving on_


#### Callable and Runnable Objects

    class Printer

      def self.to_proc
        Proc.new {|x| print x}
      end

    end

    %i{a b c d e}.each(&Printer) #=> abcde

    # same as

    myproc = Printer.to_proc
    %i{a b c d e}.each(&myproc) #=> abcde

    # same as - because proc == proc.to_proc

    myproc = Printer.to_proc
    %i{a b c d e}.each(&myproc.to_proc.to_proc.to_proc) #=> abcde


Symbol.to_proc trick useful for when a method doesn't take any arguments

    class Symbol
      def to_proc
        Proc.new {|obj| obj.send(self) } #<-- note self is the method as a symbol, like :capitalize
      end
    end

    class Fixnum
      def one
        puts self
      end
    end

    [1,2,3].map(&:one) #=> 123



Procs can accept a splat in the block argument list

    pr = Proc.new {|*x| p x }
    pr.call()
    pr.call(1)
    pr.call(2)



#### instance_eval


>
__instance_eval__ is mostly useful for breaking in to what would normally be
another object's private data - particularly instance variables.

    class MyClass

      attr_accessor :var

      def initialize(data)
        self.var = data
      end

    end

    o = MyClass.new(:hello)

    o.instance_eval do
      p self.var #=> hello
    end

instance_eval has a close cousin called __instance_exec__. The difference between
the two is that __instance_exec__ can take arguments. Any arguments you pass it will
be passed, in turn, to the code block.  This enables you to do things like this:

    string = "A sample string"
    string.instance_exec("s") {|delim| self.split(delim) } #=> all this to use 'self'?

The most useful eval: **class_eval** (a.k.a. module_eval)

Class eval puts you inside the class definition

    class MyClass
      attr_accessor :var
      def initialize(data)
        self.var = data
      end
    end

    MyClass.class_eval do
      def upcase
        var.upcase
      end
    end

    o = MyClass.new(:hello)

    p o.upcase #=> :HELLO


>
But you can do some things with class_eval that you can't do with the
regular class keyword:
- Evaluate a string in a class-definition context
- Open the class definition of any anonymous class (not just singleton classes)
- Use existing local variables inside a class definition body

Using local variable inside class definition, but you have to also use define method (flatten scopes)
_class_eval "flattens scopes" when creating classes_

    C = Class.new

    var = :hello

    C.class_eval do

      define_method(:return_var) do
        var
      end

    end

    p C.new.return_var #=> :hello

>
When you open a class with the class keyword, you start a new local-variable
scope. But the block you use with class_eval can see the variables created in
the scope surrounding it. 


def inside a instance_eval creates a method on the classes eigenclass, aka, class method, just like
it would defining a method on an ordinary object with instance_eval

    C = Class.new
    C.instance_eval do
      def hello
        :hello_from_instance
      end
    end

    p C.hello #=> :hello_from_instance (instance of Class, aka eigenclass)


class_eval on a class just reopens the class, but its a way to dynamically define method with define_method(:method)

    C = Class.new
    C.class_eval do
      def hello
        :hello_from_class
      end
    end

    p C.new.hello #=> :hello_from_class


_NOTE: don't rely on bindings and closures for instnce_eval, it can do weird things_



####  Parallel execution with threads

_Moving on - I'm more of an event-driven guy_



### Callbacks, hooks, and runtime introspection



method_missing as a delegate/forwardable

    class Cookbook
      attr_accessor :title, :author
      def initialize
        @recipes = []
      end
      def method_missing(m,*args,&block)
        @recipes.send(m,*args,&block)
      end
    end

    c = Cookbook.new
    c << :rice
    c.concat [:beer, :flour, :pepper]

    p c.to_a #=> [:rice, :beer, :flour, :pepper]


forwardable alternative, limitation is that all delegated methods need to be explicit

    require 'forwardable'

    class Cookbook

      extend Forwardable #<-----
      def_delegators :@recipes, :<<, :concat, :to_a

      attr_accessor :title, :author

      def initialize
        @recipes = []
      end

    end

    c = Cookbook.new
    c << :rice
    c.concat [:beer, :flour, :pepper]

    p c.to_a #=> [:rice, :beer, :flour, :pepper]



Module#included

    module MyModule
      def self.included(c) #<-- class method
        p "#{c} included"
      end
    end

    MyClass = Class.new

    MyClass.class_eval do
      include MyModule
    end

Module#extend works the same way

    module MyModule
      def self.extended(c)
        print "#{c} extended "
      end
      def hello
        p :hello
      end
    end

    MyClass = Class.new

    MyClass.class_eval do
      extend MyModule
    end

MyClass.hello #=> MyClass extended :hello


>
When would it be useful for a module to intercept its own inclusion like this?
One commonly discussed case revolves around the difference between instance and
class methods. When you mix a module into a class, you're ensuring that all the
instance methods defined in the module become available to instances of the
class. But the class object isn't affected. The following question often
arises: What if you want to add class methods to the class by mixing in the
module along with adding the instance methods?


    module MyMixedModule

      def self.included(klass)
        klass.extend(ClassMethods)
      end

      def instance_method
        p "hello from instance_method"
      end

      module ClassMethods
        def class_method
          p "hello from class_method"
        end
      end

    end

    class MyClass
      include MyMixedModule
    end

    MyClass.new.instance_method #=> "hello from instance_method"
    MyClass.class_method        #=> "hello from class_method"



In effect, extending an object with a module is the same as including that
module in the object's singleton class. Whichever way you describe it, the
upshot is that the module is added to the object's method-lookup path, entering
the chain right after the object's singleton class. 

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


#### Class#inherited

    class A
      def self.inherited(klass)
        p "#{B} inherited #{A}"
      end
    end

    class B < A #=> B inherited A
    end

#### Module#const_missing and const_set

    class MyClass
      def self.const_missing(const)
        const_set(const, :hello)
        "#{self} #{const}"
      end
    end

    p MyClass::A #=> "MyClass A"
    p MyClass::A #=> :hello

__method_added__ and __singleton_method_added__ methods exist but you probably wont ever use them... Moving on



#### Interpreting object capability queries ( introspection? )

>
With method_missing, you can arrange for an object to provide a response when
sent a message for which it has no corresponding method. But respond_to?
won't know about such messages and will tell you that the object
doesn't respond to the message even though you get a useful response
when you send the message to the object. Some Rubyists like to override
respond_to? so that it incorporates the same logic as method_missing for a
given class. That way, the results of respond_to? correspond more closely to
the specifics of what messages an object can and can't make sense of. 

>
Others prefer to leave respond_to? as it stands, on the grounds that
it's a way to check whether an object already has the ability to
respond to a particular message without the intervention of method_missing.
Given that interpretation, respond_to?  corresponds closely to the results of
methods. In both cases, the scope of operations is the entirety of all public
methods of a given object. 

>
If you want to know which of the methods defined in the Enumerable module are
overridden in Range? You can find out by performing an and (&) operation on the
two lists of instance methods: those defined in Enumerable and those defined in
Range:


Range.instance_methods(false) & Enumerable.instance_methods(false)


Getting object singleton methods

    MyClass = Class.new

    class << MyClass
      def hello
        p :hello_from_singleton_method
      end
    end

    p MyClass.singleton_methods #=> [:hello]



Getting methods that are only inherited

    File.singleton_methods - File.singleton_methods(false)

Getting variables

    local_variables
    global_variables


page 461







## Effective Javascript


### Item 1: Know Which Javascript You Are Using

>
...many JavaScript engines support a const keyword for defining variables, yet the
ECMAScript standard does not provide any definition for the syntax or behavior
of const. Moreover, the behavior of const differs from implementation to
implementation.

>
ES5 introduced another versioning consideration with its strict mode.

    "use strict";

>
- Decide which versions of JavaScript your application supports.
- Be sure that any JavaScript features you use are supported by all
environments where your application runs.
- Always test strict code in environments that perform the strictmode
checks.
- Beware of concatenating scripts that differ in their expectations
about strict mode.

### Item 2: Understand Javascripts Floating Point Numbers

>
... all numbers in JavaScript are double-precision floating-point numbers, that
is, the 64-bit encoding of numbers specified by the IEEE 754 standard -
commonly known as "doubles."

    typeof 1 //=> "number"
    typeof 2 //=> "number"

Ugh

    .2 + .1 //=> 0.30000000000000004 

>
- JavaScript numbers are double-precision floating-point numbers.
- Integers in JavaScript are just a subset of doubles rather than a
  separate datatype.
- Bitwise operators treat numbers as if they were 32-bit signed integers.
- Be aware of limitations of precisions in floating-point arithmetic.

### Item 3: Beware of Implicit Coercions

Ugh

    3 + true //=> 4

>
Since NaN is the only JavaScript value that is treated as unequal to itself,
you can always test if a value is NaN by checking it for equality to itself:

    var a = NaN;
    a !== a; //=> true

>
Objects can also be coerced to primitives. This is most commonly
used for converting to strings:

    "the Math object: " + Math; //=> "the Math object: [object Math]"
    "the JSON object: " + JSON; //=> "the JSON object: [object JSON]"


>
Objects are converted to strings by implicitly calling their toString
method. You can test this out by calling it yourself:

    Math.toString(); // "[object Math]"
    JSON.toString(); // "[object JSON]"

>
Similarly, objects can be converted to numbers via their valueOf
method. You can control the type conversion of objects by defining
these methods:

    "J" + { toString: function() { return "S"; } }; //=> "JS"
    2 * { valueOf: function() { return 3; } }; //=> 6

valueOf overrides toString, so only use valueOf for numberish objects

    var obj = {
      toString: function() {
        return "[object MyObject]";
      },
      valueOf: function() {
        return 17;
      }
    };

    "object: " + obj; //=> "object: 17"

>
Most JavaScript values are truthy, that is, implicitly coerced to true.  There
are exactly seven falsy values: false, 0, -0, "", NaN, null, and undefined. All
other values are truthy.

>
The more precise way to check for undefined is to use typeof:

    typeof y === "undefined"

    # or

    if (x === undefined) { ... }


>
* Type errors can be silently hidden by implicit coercions.
* The + operator is overloaded to do addition or string concatenation
  depending on its argument types.
* Objects are coerced to numbers via valueOf and to strings via
  toString.
* Objects with valueOf methods should implement a toString method
  that provides a string representation of the number produced by
  valueOf.
* Use typeof or comparison to undefined rather than truthiness to
  test for undefined values.

### Item 4: Prefer Primitives to Object Wrappers

>
In addition to objects, JavaScript has five types of primitive values:
booleans, numbers, strings, null, and undefined. (Confusingly, the typeof
operator reports the type of null as "object", but the ECMAScript standard
describes it as a distinct type.) 


>
At the same time, the standard library provides constructors for wrapping
booleans, numbers, and strings as objects. You can create a String object that
wraps a string value:

    var s = new String("hello");

That you can't compare the contents of two distinct String objects using
built-in operators.

    console.log("hello" === 'hello'); //=> true
    console.log(new String("hello") === new String('hello')); //=> false

>
**Since these wrappers don't behave quite right, they don't serve much of a
purpose.** The main justification for their existence is their utility methods.
JavaScript makes these convenient to use with another implicit coercion: You
can extract properties and call methods of a primitive value, and it acts as
though you had wrapped the value with its corresponding object type. For
example, the String prototype object has a toUpperCase method, which converts a
string to uppercase.  You can use this method on a primitive string value:

    "hello".toUpperCase(); // "HELLO"


>
Ugh... A strange consequence of this implicit wrapping is that you can set
properties on primitive values with essentially no effect.  Since the implicit
wrapping produces a new String object each time it occurs, the update to the
first wrapper object has no lasting effect. 

    "hello".someProperty = 17;
    "hello".someProperty; // undefined

The wrapping doesn't seem to change the type, is that right?

    var str = 'hello';
    console.log(typeof str) //=> string
    str.toUpperCase()
    console.log(typeof str) //=> string

>
* Object wrappers for primitive types do not have the same behavior
as their primitive values when compared for equality.
* Getting and setting properties on primitives implicitly creates object
wrappers.

### Item 5: Avoid using == with Mixed Types


Ugh

    "1.0e0" == { valueOf: function() { return true; } };


>
**When the two arguments are of the same type, there's no difference in
behavior between == and ===.**

Looks like good advice.
>
So if you know that the arguments are of the same type, they are
interchangeable. But using strict equality is a good way to make it clear to
readers that there is no conversion involved in the comparison. Otherwise, you
require readers to recall the exact coercion rules to decipher your code's
behavior.

    var date = new Date("1999/12/31");
    date == "1999/12/31"; //=> false

>
But the mistake is symptomatic of a more general misunderstanding of coercions.
The == operator does not infer and unify arbitrary data formats. It requires
both you and your readers to understand its subtle coercion rules.

>
* The == operator applies a confusing set of implicit coercions when
   its arguments are of different types.
* Use === to make it clear to your readers that your comparison does
   not involve any implicit coercions.
* Use your own explicit coercions when comparing values of different
   types to make your program's behavior clearer.



### Item 6: Learn the Limits of Semicolon Insertion

__Um, I'll just use semis so I don't have to know these rules.__


### Item 7: Think of Strings As Sequences of 16-Bit Code Units

>
* JavaScript strings consist of 16-bit code units, not Unicode code
points.
* Unicode code points 216 and above are represented in JavaScript by
two code units, known as a surrogate pair.
* Surrogate pairs throw off string element counts, affecting length,
charAt, charCodeAt, and regular expression patterns such as ".".
* Use third-party libraries for writing code point-aware string
manipulation.
* Whenever you are using a library that works with strings, consult
the documentation to see how it handles the full range of code
points.


### Item 8: Minimize Use of the Global Object

_duh_

### Item 9: Always Declare Local Variables


Watch out for accidental globals

    function swap(a, i, j) {
     temp = a[i]; // global
     a[i] = a[j];
     a[j] = temp;
    }

Using "use strict" wouln't let the above pass.


### Item 10: Avoid with

_No problem - didn't even know about it until you mentioned it_


### Item 11: Get Comfortable with Closures

_OK done_



### Item 12: Understand Variable Hoisting

>
JavaScript does not support block scoping: Variable definitions are not scoped
to their nearest enclosing statement or block, but rather to their containing
function.

... the variable is in scope for the entire function, but it is only assigned
at the point where the var statement appears. 

Hoisting can also lead to confusion about variable redeclaration. It is legal
to declare the same variable multiple times within the same function.

Strict doesn't help this runaway loop

    "use strict";

    for ( var i = 0; i < 10; i++ ) {
      var i = 0;
      console.log( i );
    }

The one exception to JavaScript's lack of block scoping is, appropriately
enough, exceptions. That is, try..catch binds a caught exception to a variable
that is scoped just to the catch block:

>
* Variable declarations within a block are implicitly hoisted to the top
of their enclosing function.
* Redeclarations of a variable are treated as a single variable.
* Consider manually hoisting local variable declarations to avoid
confusion.



### Item 13: Use Immediately Invoked Function Expressions to Create Local Scopes



>
* Closures capture their outer variables by reference, not by value.
* Use immediately invoked function expressions (IIFEs) to create local
scopes.



### Item 14: Beware of Unportable Scoping of Named Function Expressions

Use named function for recursion

    var cd = function count_down( start ) { //<--- count_down

      if ( start == 0 ) {
        return;
      }
      console.log( start );
      count_down( start - 1 ); //<--- count_down

    }

    cd(10);

    // scoped to function only
    console.log(typeof count_down) //=> 'undefined'
    console.log(typeof count_down === 'undefined') //=> true

NOTE: you can use the 'cd' var in place of count_down, so we didn't get much for naming the function

Javascript is a mess;

    var a;
    console.log(a) //=> undefined
    console.log(typeof a) //=> undefined (might be 'undefined' depending on how console.log works
    console.log(a === undefined) //=> true
    console.log(typeof a === undefined) //=> false
    console.log(typeof a === 'undefined') //=> true


>
The real usefulness of named function expressions, though, is for debugging.
Most modern JavaScript environments produce stack traces for Error objects, and
the name of a function expression is typically used for its entry in a stack
trace.



>
* Use named function expressions to improve stack traces in Error
objects and debuggers.
* Consider avoiding named function expressions or removing them
before shipping.
* If you are shipping in properly implemented ES5 environments,
you've got nothing to worry about.

### Item 15: Beware of Unportable Scoping of Block-Local Function Declarations

>
*  Always keep function declarations at the outermost level of a program
or a containing function to avoid unportable behavior.
* Use var declarations with conditional assignment instead of conditional
function declarations.


### Item 19: Get Comfortable Using Higher-Order Functions

>
* Higher-order functions are functions that take other functions as
arguments or return functions as their result.
* Familiarize yourself with higher-order functions in existing
libraries.
* Learn to detect common coding patterns that can be replaced by
higher-order functions.


### Item 20: Use call to Call Methods with a Custom Receiver


_Note: call() is a method property of functions, not ordinary objects_

>
* Use the call method to call a function with a custom receiver
* Use the call method for calling methods that may not exist on a
given object.
* Use the call method for defining higher-order functions that allow
clients to provide a receiver for the callback.

### Item 21: Use apply to Call Functions with Different Numbers of Arguments


javascripts version of splat

    function average(){
      var count = 0;
      for(var i = 0; i<arguments.length; i++){
        count = count + arguments[i];
      }
      return count/arguments.length;
    }

    var a = [1,2,3,4,5];
    console.log(average.apply(null, a)) //=> 3

>
* Use the apply method to call variadic functions with a computed
array of arguments.
* Use the first argument of apply to provide a receiver for variadic
methods.


### Item 22: Use arguments to Create Variadic Functions

* Use the implicit arguments object to implement variable-arity
functions.
* Consider providing additional fixed-arity versions of the variadic
functions you provide so that your consumers don't need to use the
apply method.



### Item 23: Never Modify the arguments Object



Make real arguments array from existing one;

    var args = [].slice.call(arguments);


>
* Never modify the arguments object.
* Copy the arguments object to a real array using [].slice.call(arguments)
before modifying it.


### Item 24: Use a Variable to Save a Reference to arguments

>
* Be aware of the function nesting level when referring to arguments.
* Bind an explicitly scoped reference to arguments in order to refer to
  it from nested functions.


### Item 25: Use bind to Extract Methods with a Fixed Receiver

    var a = [ 1, 2, 3, 4, 5 ];
    var s = a.slice;
    console.log( s() ) //=> []

    var s = a.slice.bind( a );
    console.log( s() ) //=> [1,2,3,4,5]

Another example, replacing a callback function definition with a function


var buffer = {
  data: [],
  add: function( s ) {
    this.data.push( s )
  },
}

buffer.add( 1 );
buffer.add( 2 );
buffer.add( 3 );
console.log( buffer.data );

var a = ['a', 'b', 'c']

// using a wrapper function for calling buffer.add
a.forEach(function(x){
  buffer.add(x)
})

var a = ['x', 'y', 'z']

// directly calling buffer add, but we need a bind
a.forEach(buffer.add.bind(buffer))

console.log( buffer.data ); //=> [ 1, 2, 3, 'a', 'b', 'c', 'x', 'y', 'z' ]


>
* Beware that extracting a method does not bind the method's
receiver to its object.
* When passing an object's method to a higher-order function, use an
anonymous function to call the method on the appropriate receiver.
* Use bind as a shorthand for creating a function bound to the appropriate
receiver.


### Item 26: Use bind to Curry Functions

Eventhough the first arg to bind is 'this', you don't have to use it.

Example of conditioning method to pass to map()

    var highlighter = function(pointer, value){
      console.log(pointer + value);
    };

    // pass wrapper to map
    [1,2,3,4,5].map(function(x){
      highlighter('*** ', x);
    });

    // use bind to convert highlighter into one argument method
    [1,2,3,4,5].map(highlighter.bind(null, '--> '));

* Use bind to curry a function, that is, to create a delegating function
with a fixed subset of the required arguments.
* Pass null or undefined as the receiver argument to curry a function
that ignores its receiver.


### Item 28: Avoid Relying on the toString Method of Function

>
* JavaScript engines are not required to produce accurate reflections
of function source code via toString.
* Never rely on precise details of function source, since different
engines may produce different results from toString.
* The results of toString do not expose the values of local variables
stored in a closure.
* In general, avoid using toString on functions


### Item 29: Avoid Nonstandard Stack Inspection Properties

>
* Avoid the nonstandard arguments.caller and arguments.callee,
because they are not reliably portable.
* Avoid the nonstandard caller property of functions, because it does
not reliably contain complete information about the stack.


### Item 30: Understand the Difference between prototype, getPrototypeOf, and __proto__

>
Prototypes involve three separate but related accessors, all of which are named
with some variation on the word prototype. This unfortunate overlap naturally
leads to quite a bit of confusion.

>
Classes in JavaScript are essentially the combination of a constructor function
(User) and a prototype object used to share methods between instances of the
class (User.prototype).

>
* C.prototype determines the prototype of objects created by new C().
* Object.getPrototypeOf(obj) is the standard ES5 function for retrieving
the prototype of an object.
* obj.__proto__ is a nonstandard mechanism for retrieving the prototype
of an object.
* A class is a design pattern consisting of a constructor function and
an associated prototype.

### Item 31: Prefer Object.getPrototypeOf to __proto__

>
ES5 introduced Object.getPrototypeOf as the standard API for
retrieving an object's prototype, but only after a number of JavaScript
engines had long provided the special __proto__ property for the same
purpose. 

Unreliable in some envs

    var empty = Object.create(null); // object with no prototype
    "__proto__" in empty; // false (in some environments)
    "__proto__" in empty; // true (in some environments)


>
* Prefer the standards-compliant Object.getPrototypeOf to the nonstandard
__proto__ property.
* Implement Object.getPrototypeOf in non-ES5 environments that
support __proto__.


### Item 32: Never Modify __proto__

* Never modify an object's __proto__ property.
* Use Object.create to provide a custom prototype for new objects.


### Item 33: Make Your Constructors new-Agnostic

    function User( name, passwordHash ) {
      if ( !( this instanceof User ) ) {
        return new User( name, passwordHash );
      }
      this.name = name;
      this.passwordHash = passwordHash;
    }

Version using Object.create()

    function User( name, passwordHash ) {
      var self = this instanceof User ? this : Object.create( User.prototype );
      self.name = name;
      self.passwordHash = passwordHash;
      return self;
    }

>
Protecting a constructor against misuse may not always be worth the trouble,
especially when you are only using a constructor locally.

>
* Make a constructor agnostic to its caller's syntax by reinvoking
itself with new or with Object.create.
* Document clearly when a function expects to be called with new


### Item 34: Store Methods on Prototypes

>
* Storing methods on instance objects creates multiple copies of the
functions, one per instance object.
* Prefer storing methods on prototypes over storing them on instance
objects.


### Item 35: Use Closures to Store Private Data

_no good example provided by good_

My attempt at an example:

    function MyConstructor(){
      var data = data;
      return {
        get_data: function(){ return data},
        set_data: function(value){ data = value }
      }
    }

   var obj = new MyConstructor;
    obj.set_data(123);
    console.log(obj.get_data());

_Downside to the above is that the methods need to be defined within the
constructor and not on the prototype.

>
* Closure variables are private, accessible only to local references.
* Use local variables as private data to enforce information hiding
within methods.


### Item 36: Store Instance State Only on Instance Objects

    function Tree(x) {
      this.value = x;
    }

    Tree.prototype = {
      children: [], //<---- should be instance state!!!!
      addChild: function( x ) {
        this.children.push( x );
      }
    };


>
* Mutable data can be problematic when shared, and prototypes are
shared between all their instances.
* Store mutable per-instance state on instance objects.


### Item 37: Recognize the Implicit Binding of this

>
Every function has an implicit binding of this, whose value is determined when
the function is called.

__remember that everytime we enter a function, this is assigned to something else, and
if we are using 'use strict' its probably being set to undefined.__

Bug version, wrong this

    function Data( data, splitter ) {
      this._data = data;
      this._splitter = splitter;
    }

    Data.prototype.split = function() {
      return this._data.map( function( x ) {
        console.log(this) //<-- either global this or undefined because of 'use strict'
        return x.split( this._splitter ) //<-- cannot read property of this
      } )
    }

    var data = new Data( ['abc','def'], new RegExp( '' ) )
    console.log( data.split() );


that this technique

    function Data( data, splitter ) {
      this._data = data;
      this._splitter = splitter;
    }

    Data.prototype.split = function() {
      var that = this //<-- that trick
      return this._data.map( function( x ) {
        return x.split( that._splitter ) //<-- that
      } )
    }

    var data = new Data( ['abc','def'], new RegExp( '' ) )
    console.log( data.split() );


bind technique ( more elegant but difficult to read? )

    function Data( data, splitter ) {
      this._data = data;
      this._splitter = splitter;
    }

    Data.prototype.split = function() {
      return this._data.map( function( x ) {
        return x.split( this._splitter ) //<-- that
      }.bind(this) ) //<-- bind()
    }

    var data = new Data( ['abc','def'], new RegExp( '' ) )
    console.log( data.split() );

>
* The scope of this is always determined by its nearest enclosing
function.
* Use a local variable, usually called self, me, or that, to make a
this-binding available to inner functions.


### Item 38: Call Superclass Constructors from Subclass Constructors

_revisit this one, but I don't favor class inheritance in javascript_

### Item 40: Avoid Inheriting from Standard Classes

>
The ECMAScript standard library is small, but it comes with a hand- ful of
important classes such as Array, Function, and Date. It can be tempting to
extend these with subclasses, but unfortunately their definitions have enough
special behavior that well-behaved sub- classes are impossible to write.

My limited example of delegation

    function MyArray(data){
      this._data = data
    }

    MyArray.prototype.forEach = function(f){
      this._data.forEach(f);
    }

    var a = new MyArray([1,2,3]);

    a.forEach(function(x){
      console.log(x);
    })


>
* Inheriting from standard classes tends to break due to special internal
  properties such as [[Class]].
* Prefer delegating to properties instead of inheriting from standard classes.


### Item 41: Treat Prototypes As an Implementation Detail

>
* Objects are interfaces; prototypes are implementations.
* Avoid inspecting the prototype structure of objects you don’t control.
* Avoid inspecting properties that implement the internals of objects you don’t
control.

### Item 42: Avoid Reckless Monkey-Patching

>
* Avoid reckless monkey-patching.
* Document any monkey-patching performed by a library.
* Consider making monkey-patching optional by performing the modifications in
  an exported function.
* Use monkey-patching to provide polyfills for missing standard APIs.

### Item 43: Build Lightweight Dictionaries from Direct Instances of Object

>
At its heart, a JavaScript object is a table mapping string property
names to values. 

>
prototype pollution, where properties on a prototype object can cause
unexpected properties to appear when enumerating dictionary entries.


>
* Use object literals to construct lightweight dictionaries.
* Lightweight dictionaries should be direct descendants of
Object.prototype to protect against prototype pollution in for...in
loops.

### Item 44: Use null Prototypes to Prevent Prototype Pollution


>
ES5 offers the first standard way to create an object with no prototype.

    var x = Object.create(null);
    Object.getPrototypeOf(o) === null; // true

>
No amount of prototype pollution can affect the behavior of such an object.


>
* In ES5, use Object.create(null) to create prototype-free empty
objects that are less susceptible to pollution.
* In older environments, consider using { __proto__: null }.
* But beware that __proto__ is neither standard nor entirely portable
and may be removed in future JavaScript environments.
* Never use the name "__proto__" as a dictionary key since some
environments treat this property specially. 


### Item 45: Use hasOwnProperty to Protect Against Prototype Pollution

This doesn't seem to be a problem. for..in seems to be skipping everything
except properties I define on object.  Maybe just in chrome and node, which is
v8 right?  Respecting enumerable properties with for..in loops but still showing
with 'in' operator?

    var dict = {data:null};
    console.log("toString" in dict); // true
    console.log("data" in dict); // true

    for(var p in dict){ console.log(p) }

    //=> 'data' nothing else

>
* Use hasOwnProperty to protect against prototype pollution.
* Use lexical scope and call to protect against overriding of the
hasOwnProperty method.
*Consider implementing dictionary operations in a class that encapsulates
the boilerplate hasOwnProperty tests.
* Use a dictionary class to protect against the use of "__proto__" as
a key.


### Item 46: Prefer Arrays to Dictionaries for Ordered Collections

>
The ECMAScript standard does not specify any particular order of property
storage and is even largely mum on the subject of enumeration.

* Avoid relying on the order in which for...in loops enumerate object
properties.
* If you aggregate data in a dictionary, make sure the aggregate operations
are order-insensitive.
* Use arrays instead of dictionary objects for ordered collections.


### Item 47: Never Add Enumerable Properties to Object.prototype


* Avoid adding properties to Object.prototype.
* Consider writing a function instead of an Object.prototype method.
* If you do add properties to Object.prototype, use ES5's
Object.defineProperty to define them as nonenumerable properties.


### Item 48: Avoid Modifying an Object during Enumeration

ECMA standard states:

>
If new properties are added to the object being enumerated during enumeration,
the newly added properties are not guaranteed to be visited in the active
enumeration.


>
* Make sure not to modify an object while enumerating its properties
with a for...in loop. 
* Use a while loop or classic for loop instead of a for...in loop when
iterating over an object whose contents might change during the
loop.
* For predictable enumeration over a changing data structure, consider
using a sequential data structure such as an array instead of
a dictionary object.

### Item 49: Prefer for Loops to for...in Loops for Array Iteration

>
* Always use a for loop rather than a for...in loop for iterating over
the indexed properties of an array.
* Consider storing the length property of an array in a local variable
before a loop to avoid recomputing the property lookup.


### Item 50: Prefer Iteration Methods to Loops


>
* Use iteration methods such as Array.prototype.forEach and
Array.prototype.map in place of for loops to make code more readable
and avoid duplicating loop control logic.
* Use custom iteration functions to abstract common loop patterns
that are not provided by the standard library.
* Traditional loops can still be appropriate in cases where early exit
is necessary; alternatively, the some and every methods can be used
for early exit.


### Item 51: Reuse Generic Array Methods on Array-Like Objects

>
The standard methods of Array.prototype were designed to be reusable
as methods of other objects - even objects that do not inherit
from Array. As it turns out, a number of such array-like objects crop
up in various places in JavaScript.

    function my_array() {
      [].forEach.call( arguments, function( x ) {
        console.log( x );
      } )
    }

So what exactly makes an object "array-like"? The basic contract of
an array object amounts to two simple rules.
* It has an integer length property in the range 0...232-1.
* The length property is greater than the largest index of the object.
An index is an integer in the range 0...232-2 whose string representation
is the key of a property of the object.

Good enough to be array like:

    var arrayLike = { 0: "a", 1: "b", 2: "c", length: 3 };

Strings act like immutable arrays, too, since they can be indexed
and their length can be accessed as a length property.

    var str = 'this is a string';

    [].forEach.call(str, function(x){
      console.log(x)
    })

>
* Reuse generic Array methods on array-like objects by extracting
method objects and using their call method.
* Any object can be used with generic Array methods if it has indexed
properties and an appropriate length property.


### Item 52: Prefer Array Literals to the Array Constructor

>
* The Array constructor behaves differently if its first argument is a
number.
* Use array literals instead of the Array constructor.


### Item 54: Treat undefined As "No Value"

>
The undefined value is special: Whenever JavaScript has no specific value to
provide it just produces undefined. Unassigned variables start out with the
value undefined

    var x;
    x; // undefined

    var obj = {};
    obj.x; // undefined

    function f() {
      return;
    }
    f(); // undefined

    function g() {}
    g(); // undefined

    function f(x) {
      return x;
    }
    f(); // undefined

>
* Avoid using undefined to represent anything other than the absence
of a specific value.
* Use descriptive string values or objects with named boolean properties,
rather than undefined or null, to represent application- specific
flags.
* Test for undefined instead of checking arguments.length to provide
parameter default values.
* __Never use truthiness tests for parameter default values that should
allow 0, NaN, or the empty string as valid arguments.__


### Item 55: Accept Options Objects for Keyword Arguments

>
* Use options objects to make APIs more readable and memorable.
* The arguments provided by an options object should all be treated
as optional.
* Use an extend utility function to abstract out the logic of extracting
values from options objects.


### Item 56: Avoid Unnecessary State

>
* Prefer stateless APIs where possible. _(not sure about this one)_
* When providing stateful APIs, document the relevant state that
each operation depends on.


### Item 58: Distinguish between Array and Array-Like


>
* Never overload structural types with other overlapping types.
* When overloading a structural type with other types, test for the
other types first.
* Accept true arrays instead of array-like objects when overloading
with other object types.
* Document whether your API accepts true arrays or array-like
values.
* Use ES5's Array.isArray to test for true arrays.


### Item 60: Support Method Chaining

>
* Use method chaining to combine stateless operations.
* Support method chaining by designing stateless methods that produce
new objects.
* Support method chaining in stateful methods by returning this.



## The Principles of Object-Oriented Javascript

#### Primitive Types

* Boolean
* Number 
* String 
* Null 
* Undefined

>
In JavaScript, as in many other languages, a variable holding a primitive
directly contains the primitive value (rather than a pointer to an object).
When you assign a primitive value to a variable, the value is copied into that
variable. This means that if you set one variable equal to another, each
variable gets its own copy of the data. 


    var color1 = 'red';
    var color2 = color1; //<-- 'red' copied into color2, not a reference
    var color1 = 'blue'
    console.log(color1, color2) //=> blue red


#### Identifying Primitive Types

>
The best way to identify primitive types is with the typeof operator, which
works on any variable and returns a string indicating the type of data. 

    console.log(typeof "Nicholas"); // "string"
    console.log(typeof 10); // "number"
    console.log(typeof 5.1); // "number"
    console.log(typeof true); // "boolean"
    console.log(typeof undefined); // "undefined"

Bug:

    console.log(typeof null); //=> "object"

>
The best way to determine if a value is null is to compare it against
null directly, like this:

    console.log(value === null); // true or false


#### Primitive Methods

>
Despite the fact that they're primitive types, strings, numbers, and Booleans
actually have methods. (The null and undefined types have no methods.) 

>
Despite the fact that they have methods, primitive values themselves are not
objects.  JavaScript makes them look like objects to provide a consistent
experience in the language, as you'll see later in this chapter.


#### Reference Types

Unlike primitive types, assigning a reference type to a variable assigns its
pointer (maybe that's why they are called reference types?)

var o1 = new Object();
var o2 = o1

console.log(o1 == o2)  //=> true
console.log(o1 === o2) //=> true


>
JavaScript is a garbage-collected language, so you don’t really need to worry
about memory allocations when you use reference types. However, it’s best to
dereference objects that you no longer need so that the garbage collector can
free up that memory. The best way to do this is to set the object variable to
null.

    var object1 = new Object();
    // do something
    object1 = null;

Instantiate built-in reference types

    var items = new Array();
    var now = new Date();
    var error = new Error("Something bad happened.");
    var func = new Function("console.log('Hi');");
    var object = new Object();
    var re = new RegExp("\\d+");

Example of object literal syntax

    var book = {
        "name": "The Principles of Object-Oriented JavaScript",
        "year": 2014
    };

Exaple of same with new (constructor form?)

    var book = new Object();
    book.name = "The Principles of Object-Oriented JavaScript";
    book.year = 2014;

>
Using an object literal doesn’t actually call new Object(). Instead, the
JavaScript engine follows the same steps it does when using new Object()
without actually calling the constructor. This is true for all reference
literals.

Array literal and constructor forms

    var colors = [ "red", "blue", "green" ];

    var colors = new Array("red", "blue", "green")

>
You almost always define functions using their literal form.

Not this

    var reflect = new Function("value", "return value;");

Regex literal and constructor forms

    var numbers = /\d+/g;
    var numbers = new RegExp("\\d+", "g");

>
The literal form of regular expressions in JavaScript is a bit easier
to deal with than the constructor form because you don’t need to worry about
escaping characters within strings.

>
Regular expression literals are preferred over the construc- tor form in
JavaScript except when the regular expression is being con- structed
dynamically from one or more strings.

>
That said, with the exception of Function, there really isn’t any right or
wrong way to instantiate built-in types. Many developers prefer literals, while
some prefer constructors. Choose whichever method you find more comfortable to
use.


#### identifying reference Types

    var func = function(){}
    console.log(typeof func) //=> function

>
Other reference types are trickier to identify because, for all reference types
other than functions, __typeof__ returns "object".

    var a = [];
    console.log(typeof a) //=> object


The instanceof operator takes an object and a constructor as param- eters. When
the value is an instance of the type that the constructor speci- fies,
instanceof returns true; otherwise, it returns false

    var a = [];
    console.log(a instanceof Array) //=> true
    console.log(a instanceof Object) //=> true

    var b = {};
    console.log(b instanceof Object) //=> true


>
The instanceof operator can identify inherited types. That means every object
is actually an instance of Object because every reference type inherits from
Object.


#### Primative Wrapper Types

>
Perhaps one of the most confusing parts of JavaScript is the concept of
primitive wrapper types. There are three primitive wrapper types (String,
Number, and Boolean). These special reference types exist to make working with
primitive values as easy as working with objects. (It would be very confusing
if you had to use a different syntax or switch to a procedural style just to
get a substring of text.)

A temporary wrapper object is automatically created for the primative time so
it looks like it has methods, but it goes away quickly.

    var name = "Nicholas";
    var firstChar = name.charAt(0);
    console.log(firstChar); //=> "N"

instanceof doesn't work of primatives because the primative wrapper isn't
automatically created because its only created when the value is read (or
written to?).

    var name = "Nicholas";
    var count = 10;
    var found = false;
    console.log(name instanceof String);    // false
    console.log(count instanceof Number);   // false
    console.log(found instanceof Boolean);  // false

Just creates an object

    var name = new String("Nicholas");
    var count = new Number(10);
    var found = new Boolean(false);
    console.log(typeof name); //=> object
    console.log(typeof count); //=> object
    console.log(typeof found); //=> object

You can create the wrapper by hand but its garbage

    var found = new Boolean(false);
    if (found) {
      console.log("Found"); //=> Found
    }


>
Manually instantiating primitive wrappers can also be confusing in other ways,
so unless you find a special case where it makes sense to do so, you should
avoid it. Most of the time, using primitive wrapper objects instead of
primitives only leads to errors.

>
You can use typeof to identify primitive types with the exception of null,
which must be compared directly against the special value null.

#### Function Declarations vs. Expressions

Declaraton

    function add(num1, num2) {
     return num1 + num2;
    }

Function Expression

    var add = function(num1, num2) {
     return num1 + num2;
    };


>
Although these two forms are quite similar, they __differ in a very important
way__. Function declarations are __hoisted__ to the top of the context (either the
function in which the declaration occurs or the global scope) when the code is
executed. That means you can actually define a function after it is used in
code without generating an error. 

>
The arguments object is automatically available inside any function. This means
named parameters in a function exist mostly for convenience and don't actually
limit the number of arguments that a function can accept.

>
The arguments object is not an instance of Array and therefore doesn't have the
same methods as an array; Array.isArray(arguments) always returns false.

>
In practice, checking the named parameter against undefined is more common than
relying on arguments.length.

    var func = function( a, b, c ) {
      if ( undefined == a ) {
        console.log( "a is undefined" )
      }
    }



#### methods that manipulate 'this'

##### call()

First of three methods that manipulates 'this'

    var obj = {
      name: 'kevin'
    }

    var func = function(greeting) {
      console.log( greeting +" "+ this.name )
    }

    func.call( obj , "hello") //=> hello kevin


##### apply()

Second of three methods that manipulates 'this'

    var obj = {
      name: 'kevin'
    }

    var func = function( greeting ) {
      console.log( greeting + " " + this.name )
    }

    func.apply( obj, [ "hello" ] ) //=> hello kevin


##### bind()

Third of three methods that manipulates 'this' added in ECMAScript5

bind is like a sticky call(), nerds call it currying

    var obj = {
      name: 'kevin'
    }

    var func = function( greeting ) {
      console.log( greeting + " " + this.name )
    }


bind first argument. like call(), its first argument is 'this'

    var boundFunc = func.bind(obj)
    boundFunc('goodbye') //=> goodbye kevin

bind two arguments

    var boundFunc = func.bind(obj, 'adios')
    boundFunc() //=> adios kevin



#### Understanding Objects

Unreliable check for a property on objects

    if (person1.age) {
     // do something with age
    }

>
The problem with this pattern is how JavaScript's type coercion affects the
outcome. The if condition evaluates to true if the value is truthy (an object,
a nonempty string, a nonzero number, or true) and evaluates to false if the
value is falsy (null, undefined, 0, false, NaN, or an empty string). 

>
A more reliable way to test for the existence of a property is with the in
operator.  Like as key?() in ruby.

    var person1 = {
      name: "Nicholas",
      sayName: function() {
        console.log( this.name );
      }
    };

    console.log( "sayName" in person1 ); //=> true

>
In most cases, the in operator is the best way to determine whether the
property exists in an object. __It has the added benefit of not evaluating the
value of the property__, which can be important if such an evaluation is likely
to cause a performance issue or an error.

>
In some cases, however, you might want to __check for the existence of a
property only if it is an own property__. The __in operator checks for both own
properties and prototype properties__, so you'll need to take a different
approach.

>
hasOwnProperty(), which is present on all objects and returns true only if the
given property exists and is an own property.

    console.log("toString" in person1); // true
    console.log(person1.hasOwnProperty("toString")); // false


>
By default, all properties that you add to an object are enumerable, which
means that you can iterate over them using a for-in loop.

    var property;
    for (property in object) {
      console.log("Name: " + property);
      console.log("Value: " + object[property]);
    }



>
If you just need a list of an object's properties to use later in your program,
ECMAScript 5 introduced the Object.keys() method to retrieve an array of
enumerable property names

    var obj = new Object();
    obj.one = 1;
    obj.two = 2;
    obj.three = 3;

    console.log( Object.keys( obj ) ); //=> ['one', 'two', 'three']


>
There is a difference between the enumerable properties returned in a for-in
loop and the ones returned by Object.keys(). The for-in loop also enumerates
prototype properties, while Object.keys() returns only own (instance)
properties.


#### Types of Properties

>
There are two different types of properties: data properties and accessor
properties. 

kludge accessor property syntax (node the 'get' and 'set')

    var myobj = {

      _data: null,

      get data() {
        return this._data;
      },

      set data( data ) {
        this._data = data;
      }

    };

    myobj.data = [ 'a', 'b', 'c' ];
    console.log( myobj.data ) //=> [ 'a', 'b', 'c' ]


>
You don't need to define both a getter and a setter; you can choose one or
both.  If you define only a getter, then the property becomes read-only, and
attempts to write to it will fail silently in nonstrict mode and throw an error
in strict mode.  If you define only a setter, then the property becomes
write-only, and attempts to read the value will fail silently in both strict
and nonstrict modes.

Note, access to myobj._null is still possible even with getters and setters.

defineProperty() with "enumerable"

    var myobj = {
      hello: 'there'
    };

    // change enumerable
    console.log( 'hello' in myobj ) //=> true
    console.log( Object.keys( myobj ) ) //=> ['hello']
    console.log( myobj.propertyIsEnumerable( 'hello' ) ) //=> true

    Object.defineProperty( myobj, 'hello', {
      enumerable: false
    } )

    console.log( 'hello' in myobj ) //=> true
    console.log( Object.keys( myobj ) ) //=> []
    console.log( myobj.propertyIsEnumerable( 'hello' ) ) //=> false


defineProperty() with "configurable" seems to be a solution in search of a problem? 


You can defineProperty along with its data

    Object.defineProperty( myobj, 'hello', {
      value: 'there',
      writable: true
    } )

    console.log(myobj.hello) //=> there

    myobj.hello = 'goodbye';
    console.log(myobj.hello) //=> goodbye


    Object.defineProperty( myobj, 'hello', {
      value: 'there',
      writable: false
    } )

    myobj.hello = 'adios'; //=> TypeError: Cannot assign to read only property 'hello' of #<Object>



>
When JavaScript is running in strict mode, attempting to delete a nonconfigurable
property results in an error. In nonstrict mode, the operation silently fails.



>
The advantage of using accessor property attributes instead of object literal
notation to define accessor properties is that you can also define those
properties on existing objects.


    var obj = {
      _data: null
    };

    Object.defineProperty( obj, 'data', {

      get: function() {
        return this._data;
      },

      set: function( val ) {
        this._data = val;
      },

    } );

    obj.data = '123';
    console.log( obj.data );


Setters and getters defined with defineProperty seem to confuse enumerable: 

Without Object.defineProperty:

    var obj = {
      _myData: null,

      get: function() {
        return this._myData;
      },

      set: function( val ) {
        this._myData = val;
      },

    };

    obj.myData = '123';

    console.log('myData' in obj) //=> true
    console.log(obj.propertyIsEnumerable('myData')) //=> TRUE


With Object.defineProperty:

    var obj2 = {_myData:null};

    Object.defineProperty( obj2, 'myData', {

      get: function() {
        return this._myData;
      },

      set: function( val ) {
        this._myData = val;
      },

    } );

    obj2.myData = '123';
    console.log( obj2.myData );

    console.log('myData' in obj2) //=> true <--- shouldn't this be false?
    console.log(obj2.propertyIsEnumerable('myData')) //=> FALSE



Object.defineProperties

    var obj = {};

    Object.defineProperties( obj, {

      _name: {
        value: 'kevin',
        enumerable: true,
      },

      name: {
        get: function() {
          return this._name
        },
        enumerable: true
      }

    } );



### Constructors and Prototypes

A constructor is simply a function that is used with new to create an object.

The new operator automatically creates an object of the given type and returns
it.

    function MyObject() {}
    var obj = new MyObject;

Every object instance is automatically created with a constructor property that
contains a reference to the constructor function that created it.

    console.log( obj instanceof MyObject ); //=> true
    console.log( obj.constructor ); //=> [Function: MyObject]
    console.log( obj.constructor === MyObject); //=> true

Ugh...

>
The constructor property can be overwritten and therefore may not be completely
accurate.

>
You can also explicitly call return inside of a constructor. If the returned
value is an object, it will be returned instead of the newly created object
instance. If the returned value is a primitive, the newly created object is
used and the returned value is ignored.

This is good...
>
An error occurs if you call the a constructor in strict mode without using new.
This is because strict mode doesn’t assign this to the global object.  Instead,
__this remains undefined__, and an error occurs whenever you attempt to create
a property on undefined.

>
Constructors allow you to configure object instances with the same properties,
but constructors alone don’t eliminate code redundancy... prototypes


>
You can determine whether a property is on the prototype by using a function
such as:

    function hasPrototypeProperty(object, name) {
      return name in object && !object.hasOwnProperty(name);
    }


Reflection example using Object.getPrototypeOf(() and instanceof

    function MyConstructor() {}

    MyConstructor.prototype = {
      hello: function() {
        console.log( 'hello' )
      }
    }

    var obj = new MyConstructor;
    obj.hello() //=> hello

    console.log(Object.getPrototypeOf(obj)) //=> { hello: [Function] }
    console.log(obj instanceof MyConstructor) //=> true

A function called with new is:

1. A constructor.
2. Creates an object, assigns it to this, and returns it implicitly
3. Sets the prototype of the created object to the 'constructor property' of
the constructor function.


Some JavaScript engines also support a property called __proto__ on all
objects.  This property allows you to both read from and write to the
[[Prototype]] property.  Firefox, Safari, Chrome, and Node.js all support this
property, and __proto__ is on the path for standardization in ECMAScript 6.

    console.log(obj.__proto__) //=> { hello: [Function] }

\__proto__ can be assigned to (why does it have to look like crap?)

    var MyPrototype = {
      hello: function() {
        console.log( 'Goodbye' )
      }
    };

    var obj = new Object;
    obj.__proto__ = MyPrototype;

    obj.hello();


As a prototype property if its the prototype of a particular object

    console.log(MyConstructor.prototype.isPrototypeOf(obj)) //=> true

Define prototype before or after?

    // before
    var MyPrototype = {
      hello: function() {
        console.log( 'Goodbye' )
      }
    };

    function MyConstructor(){}
    MyConstructor.prototype = MyPrototype;

    var obj = new MyConstructor();
    obj.hello(); //=> goodbye

    // after
    function MyConstructor(){}

    MyConstructor.prototype = {
      hello: function() {
        console.log( 'Goodbye' )
      }
    };

    var obj = new MyConstructor();
    obj.hello(); //=> goodbye

Use a prototype sort of like a class variable:

    function MyConstructor() {}

    MyConstructor.prototype.myArray = []

    var obj1 = new MyConstructor();
    var obj2 = new MyConstructor();
    var obj3 = new MyConstructor();

    obj1.myArray.push( 1 );
    obj2.myArray.push( 2 );
    obj3.myArray.push( 3 );

    console.log( obj1.myArray ); //=> [1,2,3]


Common pattern of defining a prototype by assigning an object literal

    function MyConstructor() {}

    MyConstructor.prototype = {
      sayHello: function() {
        console.log( 'hello' )
      },
      sayGoodbye: function() {
        console.log( 'goodbye' )
      },
    };

    var obj = new MyConstructor;
    obj.sayHello(); //=> hello
    obj.sayGoodbye(); //=> goodbye

>
The constructor property is actually defined on the prototype because it is
shared among object instances.

Assigning object literal to prototype wipes out the constructor property, you
might want to put it back.

    function MyConstructor() {}

    MyConstructor.prototype = {
      constructor: 'MyConstructor', //<---- put it back
      sayHello: function() {
        console.log( 'hello' )
      },
    };

    var obj = new MyConstructor;

    console.log(obj.constructor)


>
__Every function has a prototype property__ that defines any properties shared
by objects created with a particular constructor.

>
Shared methods and primitive value properties are typically defined on
prototypes, while all other properties are defined within the constructor.

>
The constructor property is actually defined on the prototype because it is
shared among object instances. (wiped out by assignment of object literal)

>
JavaScript's built-in approach for inheritance is called prototype chaining, or
prototypal inheritance.

>
Any object defined via an object literal has its [[Prototype]] set to
Object.prototype, meaning that it inherits properties from Object.prototype

>
The valueOf() method gets called whenever an operator is used on an object.
You can always define your own valueOf() method if your objects are intended to
be used with operators.

>
The toString() method is called as a fallback whenever valueOf() returns a
reference value instead of a primitive value. 

_valueOf() seems to override toString even when concating with + (makes no sense)_


Douglas Crockford recommends using hasOwnProperty() in for-in loops all
the time as a defense against monkey patching:

    for (var property in empty) {
     if (empty.hasOwnProperty(property)) {
      console.log(property);
     }
    }


Object literals have Object.prototype set as their [[Prototype]] implicitly,
but you can also explicitly specify [[Prototype]] with the Object.create()
method.

    var obj = Object.create(Object.prototype)

    // same as

    obj = {}

Second param to Object.create takes arguments as Object.defineProperties

    var obj = Object.create( Object.prototype, {
      data: {
        value: '123',
        enumerable: true
      }
    } )

    console.log( obj.data ) //=> 123


Object Inheritance: (made possible with Object.create)

    var objA = {
      hello: function() {
        console.log( 'hello' )
      }
    }

    objA.hello(); //=> hello

    var objB = Object.create(objA);

    objB.hello(); //=> hello

    console.log(objA.isPrototypeOf(objB)) //=> true


Constructor Inheritance: (assign an objects prototype to a constructor)

    function ObjA(){} //<-- constructor

    ObjA.prototype.hello = function(){
      console.log( 'hello' )
    }

    function ObjB(){} //<-- constructor

    ObjB.prototype = new ObjA; //<--- inheritance

    var objB = new ObjB;
    objB.hello(); //=> hello


>
Always make sure that you overwrite the prototype before adding properties to
it, or you will lose the added methods when the overwrite happens.


Data hiding with immediate functions (module pattern?)

    var obj = ( function() { // immediate function

      var data = null;

      return { // literal object

        get: function() {
          return data;
        },
        set: function( val ) {
          data = val;
        }

      }

    } )();


    obj.set('123');
    console.log(obj.get()); //=> 123




Creating scope safe constructors.  i.e. user forgets to use new

    function Person( name ) {
      if ( this instanceof Person ) {
        this.name = name;
      } else { // whoops!
        return new Person( name );
      }
    }



__done!__


## Speaking Javascript


>
Semicolons terminate statements, but not blocks. There is one case where you
will see a semicolon after a block: a function expression is an expression that
ends with a block. If such an expression comes last in a statement, it is
followed by a semicolon

    var myfunc = function(){};

>
Roughly, the first character of an identifier can be any Unicode letter, a
dollar sign ($), or an underscore (_). Subsequent characters can additionally
be any Unicode digit. 

    var あ = 1;
    var び = 2;
    console.log(あ + び); //=> 3


>
All values in JavaScript have properties.

>
- The primitive values are booleans, numbers, strings, null, and undefined.
- All other values are objects.

>
Each object has a unique identity and is only (strictly) equal to itself.

    var obj1 = {};
    var obj2 = {};

    console.log(obj1 === obj1) //=> true
    console.log(obj1 === obj2) //=> false


>
All primitive values encoding the same value are considered the same

    var a = 1;
    var b = 1;

    console.log(a == b) //=> true
    console.log(a === b) //=> true


>
Primitives have the following characteristics:
- Compared by value
- Always immutable


>
All nonprimitive values are objects
- Plain objects, which can be created by object literals 
- Arrays, which can be created by array literals 
- Regular expressions, which can be created by regular expression literals 
- Compared by reference
- Mutable by default


>
Javascript has two 'nonvalue' objects, undefined and null

>
- undefined means 'no value'.  
  - Uninitialized vars are undefined.
  - Missing parameters are undefined.
  - If you read an nonexistent property
- null means "no object"
  - used as a 'nonvalue' whenever an object is expected


> 
There are two operators for categorizing values: typeof is mainly used for
primitive values, while instanceof is used for objects.

    console.log( typeof 1 ) //=> number
    console.log( typeof true ) //=> boolean
    console.log( typeof 'string' ) //=> string
    console.log( typeof {} ) //=> object
    console.log( typeof [] ) //=> object
    console.log( typeof undefined ) //=> undefined
    console.log( typeof null) //=> object <--- bug!

typeof null returning 'object' is a bug that can’t be fixed, because it would
break existing code. It does not mean that null is an object.

    console.log( [] instanceof Array ); //=> true
    console.log( [] instanceof Object ); //=> true
    console.log( {} instanceof Object ); //=> true
    console.log( undefined instanceof Object ); //=> false
    console.log( null instanceof Object ); //=> false


Falsy
- undefined
- null
- false
- 0
- NaN
- ''

Truthy
- everything else

>
Boolean(), called as a function, converts its parameter to a boolean. You can use it to test how a value is interpreted

    console.log( Boolean(-0) ); //=> false

All numbers in JS are floats

    console.log( 1 === 1.00 ); //=> true

String += same as in ruby

    var str = 'a';
    str += 'b';
    str += 'c';

    console.log(str) //=> 'abc'

Loops

    for (var i=0; i < arr.length; i++) {
     console.log(arr[i]);
    }

    var i = 0;
    while (i < arr.length) {
     console.log(arr[i]);
     i++;
    }

    do {
     // ...
    } while (condition);




Optional function parameters:

    function myFunc(x,y){

      x = x || 0;
      y = y || 0;

    }


throw and catch

    function myFunc( x, y ) {
      if ( arguments.length < 2 ) {
        throw new Error( "not enough args" );
      }
    }

    try {
      myFunc();
    } catch ( exception ) {
      console.log( exception )
    }


The scope of a variable is always the complete function (as opposed to the current
block).


Each variable declaration is hoisted: the declaration is moved to the beginning
of the function, but assignments that it makes stay put.


Counter using closure:

    function counter( start ) {
      return function() {
        return start++;
      }
    }

    var c = counter( 1 );
    console.log( c() ); //=> 1
    console.log( c() ); //=> 2
    console.log( c() ); //=> 3

Something I dind't notice before, 'in' works differently in differnt contexts:

    var obj = {};
    obj.one = 1;
    obj.two = 2;

    console.log(obj); //=> { one: 1, two: 2 }

    console.log('one' in obj); //=> returns true in this context

    for (var p in obj){ //=> for context
      console.log(p);
    }


nothing happens in this context

    var p;
    while (p in obj){
      console.log(p);
    }


undefined or in, your choice

    console.log( 'one' in obj ); //=> true
    console.log( obj.one !== undefined ); //=> true




Stealing methods

    var objA = {
      name: 'objA',
      hello: function(){ console.log("hello I'm " + this.name) }
    };

    var objB ={name: 'objB'};

    objB.hello = objA.hello;
    objB.hello(); //=> "hello I'm objB"


Need to bind if not calling on a similar object

    var objA = {
      name: 'objA',
      hello: function() {
        console.log( "hello I'm " + this.name )
      }
    };

    var extracted_func = objA.hello;
    extracted_func(); //=> TypeError, cannot read property 'name'

    // bind it with 'this'
    extracted_func = extracted_func.bind(objA)
    extracted_func(); //=> hello I'm objA


"for in" works with arrays, not sure if its the best choice:

    var a = [1,2,3,4,5];

    for(var p in a){
      console.log(p)
    }

Array length can trucate arrays

    var a = [1,2,3,4,5];
    console.log(a); //=> [1,2,3,4,5]
    a.length = 3
    console.log(a); //=> [1,2,3]


Iterating over arrays

forEach()

    var a = [ 1, 2, 3, 4, 5 ];

    a.forEach( function( e, i ) {
      console.log( e, i )
    } );


map() exact same thing

    var a = [ 1, 2, 3, 4, 5 ];

    a.map( function( e, i ) {
      console.log( e, i )
    } );


regex

    console.log( /b/.test( 'abc' ) ) // true
    console.log( /z/.test( 'abc' ) ) // false

    var rematch = /(a.*c).*(g.*i)/.exec('abcdefghi')
    console.log(rematch[0]) //=> 'abcdefghi'
    console.log(rematch[1]) //=> 'abc'
    console.log(rematch[2]) //=> 'ghi'

    str = '<tag>Content</tag>';

    str = str.replace(/<(.*?)>/, '[$1]');
    console.log(str); //> "[tag]Content</tag>" <--- only first

    str = str.replace(/<(.*?)>/g, '[$1]'); // <--- global
    console.log(str); //> "[tag]Content[/tag]" <--- only first
      


>
Strict Mode: Recommended, with Caveats
* Enabling strict mode for existing code may break it
* Package with care: When you concatenate and/or minify files, you have to be
careful that strict mode isn't switched off where it should be switched on or
vice versa. Both can break code.


>
undefined and null are the only values for which any kind of property access results
in an exception

    var i;
    i.myval; //=> TypeError: Cannot read property 'myval' of undefined

    var i = undefined;
    i.myval //=> TypeError: Cannot read property 'myval' of undefined

    var i = null;
    i.myval; //=> TypeError: Cannot read property 'myval' of null

    var i = {};
    i.myval; //=> no error

always undefined (useful in ES3)

    if(x === void 0){
      //...
    }

Use wrapper objects
     
    var str = new String('abc') // NOT LIKE THIS
    var str = String(123)       // like this

    var w = Number(formData.width); // like this


The following functions are the preferred way of converting a value to a
boolean, number, string, or object (Don't use these as constructors):

    Boolean()
    Number()
    String()

The + operator for arrays is useless, it converts them to strings first:

 [1, 2] + [3] //=> '1,23'


There Are No Valid Use Cases for ==

    if(x != null) // dont
    if(x)         // do

    // not sure if x is number or string
    if (x == 123) // dont
    if (Number(x) === 123) // do



void

    void 0 // as a synonym for undefined

    // discarding the result of an expression
    javascript:void window.open("http://example.com/")

>
I added the void operator to JS before Netscape 2 shipped to make it easy to discard any
non-undefined value in a javascript: URL


>
Categorizing Values via typeof and instanceof
* The typeof operator distinguishes primitives from objects and determines the
types of primitives.
* The instanceof operator determines whether an object is an instance of a given
constructor


NaN is ridiculous

    NaN === NaN // false
    typeof NaN // 'number'

String.prototype.slice(start, end?)

    'abc'.slice(2) //=> 'c'
    'abc'.slice(1, 2) //=> 'b' (2 is end, which is exclusive)


String.prototype.substring(start, end?) Should be avoided in favor of slice(),


String.prototype.trim()

    '\r\nabc \t'.trim() //=> 'abc'


String.prototype.concat(str1?, str2?, ...)

String.prototype.toLowerCase()

String.prototype.toUpperCase()

String.prototype.indexOf(searchString, position?)

String.prototype.lastIndexOf(searchString, position?)

String.prototype.search(regexp)  //<--- regex

String.prototype.match(regexp) //<--- regex
String.prototype.replace(regexp|string, replacement) //<--- regex


Use Error constructor for throwing

    if (somethingBadHappened) {
     throw new Error('Something bad happened');
    }


Don't forget finally

  try{

  }catch(e){

    console.log(e.stack)

  }finally{ // always executed

  }


Handling specific errors (from stackexchange)

    function SpecificError () { }
    SpecificError.prototype = new Error();

    // ...

    try {
      throw new SpecificError;
    } catch (e) {
      if (e instanceof SpecificError) { //<--- instanceof
       // specific error
      } else {
        throw e; // let others bubble up
      }
    }



>
Use the delete operator sparingly. Most modern JavaScript engines optimize the
performance of instances created by constructors if their "shape" doesn't
change (roughly: no properties are removed or added). Deleting a property
prevents that optimization.


Two techniques for overcoming 'this' shadowing

    // that = this
    var obj = {
      myvar: 'hello',
      func: function() {
        var that = this; // that = this
        var inner = function() {
          log( that.myvar ); //<--- that
        }
        inner()
      }
    }

    obj.func(); //=> hello

    // bind(this)
    var obj = {
      myvar: 'hello',
      func: function() {
        var inner = function() {
          log( this.myvar );
        }.bind(this) //<--- secret sauce
        inner()
      }
    }

    obj.func(); //=> hello



>
__proto__ is not part of the ECMAScript 5 standard. Therefore, you must not use
it if you want your code to conform to that standard and run reliably across current
JavaScript engines.


>
However, more and more engines are adding support for __proto__ and it will be
part of ECMAScript 6.

>
Only getting a property considers the complete prototype chain of an object.
Setting and deleting ignores inheritance and affects only own properties.
_(should this be obvious?)_


>
Setting a property creates an own property, even if there is an inherited
property with that key.




>
Avoid invoking hasOwnProperty on an object because it may have been overridden.

    Object.prototype.hasOwnProperty.call(obj, 'foo') // safe
    {}.hasOwnProperty.call(obj, 'foo') // shorter true



__in__ works for array indices

    var a = [1,2,3];
    log( 2 in a ) //=> true
    log( 3 in a ) //=> false

__delete__ works for arrays (but not so great)

    var a = [ 1, 2, 3 ];
    log( a ); //=> [1,2,3]
    delete a[ 0 ]
    log( a ) //=> [ , 2, 3 ] //<-- what?

use __splice__ to delete array elements 

    // array.splice(start, count)
    var a = [ 1, 2, 3 ];
    a.splice(0,1);
    log(a); //=> [2,3]




clearing a shared reference to an array danger

    var a = [1,2,3];
    var b = a;

    a = []
    log(b); //=> [1,2,3] didn't work

    var a = [1,2,3];
    var b = a;

    a.length = 0
    log(b); //=> []


use filter to remove holes from array

    var a = [ 0, , , 1, , , 2, , , 3 ]
    a = a.filter(function(x){ return true });
    log(a); //=> [ 0, 1, 2, 3 ]
























## JavaScript Patterns


>
JavaScript uses functions to manage scope.

>
Every JavaScript environment has a global object accessible when you use this
outside of any function.

>
Every global variable you create becomes a property of the global object.

>
In browsers, for convenience, there is an additional property of the global
object called window that (usually) points to the global object itself. 

    // in browser console
    > myglobal = 'hello';
    > "hello"
    > window.myglobal
    > "hello"
    > this.myglobal
    > "hello"

>
...the most important pattern for having fewer globals is to always use var to
declare variables. _(seems to be the only choice when using 'use strict')_

problem with hoisting

    var myname = "global"; // global variable
    function func() {
      log( myname ); // "undefined" //<--- hoisted up from below, not the global
      var myname = "local";
      log( myname ); // "local"
    }
    func();




>
"single var pattern" _(not sure if I like this)_
  
    var i = 0,
      max = 10,
      array = [];


>
...substitute i++ with either one of these expressions: JSLint prompts you to
do it; the reason being that ++ and -- promote "excessive trickiness." 

    i = i + 1
    i += 1

>
for-in loops should be used to iterate over nonarray objects.  Looping with
for-in is also called __enumeration__.

>
It's important to use the method hasOwnProperty() when iterating over object
properties to filter out properties that come down the prototype chain.


hasOwnProperty filter on enumeration

    for ( var i in obj ) {
      if ( obj.hasOwnProperty( i ) ) { // filter
        console.log( i, ":", obj[ i ] );
      }
    }


>
Another pattern for using hasOwnProperty() is to call that method off of the
Object.prototype, in case that hasOwnProperty has been redefined (paranoid?,
not sure if this is still important with ES5 (maybe for legacy libraries))

    for (var i in man) {
      if (Object.prototype.hasOwnProperty.call(man, i)) { // filter
        console.log(i, ":", man[i]);
      }
    }


>
Using __parseInt()__ you can get a numeric value from a string. The function
accepts a second radix parameter, which is often omitted but shouldn't be.
The problems occur when the string to parse starts with 0: for example, a part
of a date entered into a form field. Strings that start with 0 are treated as
octal numbers (base 8) in ECMAScript 3;



>
You have no reason to use the new Object() constructor when you can use an object
literal

I don't even comprehend the parameter to new Object(): delegates the constructor?

    var o = new Object();
    log(o.constructor) //=> [Function: Object]

    var o = new Object(1);
    log(o.constructor) //=> [Function: Number]

    var o = new Object('hi');
    log(o.constructor) //=> [Function: String]


Use literal or Object.create (first param is either null or a prototype)

    var o = Object.create(null);
    log(o.constructor) //=> [Function: Object]


When a constructor is called with new, something like this happens behind the scenes:

    
    // var this = Object.create(Person.prototype);

Example

    function MyConstructor(){}

    MyConstructor.prototype.hello = function(){
      log('hello');
    }

    function MyConstructorImposter(){
      var obj = Object.create(MyConstructor.prototype);
      return obj;
    }

    (new MyConstructor).hello(); //=> hello
    (new MyConstructorImposter).hello(); //=> hello



Example guards to prevent calling constructor as function

    // check this (this variant only works with ES5) (handles prototype assignment correctly)
    // No danger of checking a mispelled Constructor
    function Constructor() {
      if ( !this ) throw "forgot consturctor with new"
    }

    // ignore this (handles prototype assignment correctly)
    function Constructor() {
      var that = Object.create( Constructor.prototype );
      return that;
    }

    // return object literal, no prototype assignment possible
    function Constructor() {
      return {
        hello: function() {
          log( 'hello' )
        }
      }
    }

    // self correcting
    function Constructor() {

      // ES3
      if ( !( this instanceof Constructor ) ) {
        return new Constructor;
      }

      // ES5
      if ( ! this  ) {
        return new Constructor;
      }

    }



Only reliable way to check for arrayness

    Array.isArray([]); // true



Two ways to create a regex

    var re = /.*/gmi
    var re = RegExp(".*");

>
As you can see, the regular expression literal notation is shorter and doesn't
force you to think in terms of class-like constructors.  Therefore it's
preferable to use the literal...  when using the RegExp() constructor, you also
need to escape quotes and often you need to double-escape backslashes

>
The reason to use new RegExp() is that the pattern is not known in advance but
is created as a string at runtime.

>
Calling RegExp() without new (as a function, not as a constructor)
behaves the same as with new.


Function that redefines itself;

    var changing = function() {

      log( 'do something' );

      changing = function() {
        log( 'do something else' )
      }

    }

    changing(); //=> do something
    changing(); //=> do something else


Variations of immediate functions

    var result = ( function() {
      return 2 + 2;
    }() );

    // remove outer () because when assignment not needed
    var result = function() {
      return 2 + 2;
    }();

    var result = ( function() {
      return 2 + 2;
    } )();


    // outer () required when there is no outer assignment
    ( function() {
      log( 'here' )
    } )()


Immediate object initialization pattern


both of these work:

    ({...}).init();
    ({...}.init());


Example from book (couldn't you do this with a constructor?)

    ( {
      // here you can define setting values
      // a.k.a. configuration constants
      maxwidth: 600,
      maxheight: 400,
      // you can also define utility methods
      gimmeMax: function() {
        return this.maxwidth + "x" + this.maxheight;
      },
      // initialize
      init: function() {
        console.log( this.gimmeMax() );
        // more init tasks...
      }
    } ).init();


Memoization using a functions property as a cache

    function my_add( a, b ) {

      if(my_add.cache === undefined){
        my_add.cache = [];
      }

      var cache_key = a.toString() + ',' + b.toString();
      if ( my_add.cache[ cache_key ] ) {
        return my_add.cache[cache_key]
      }

      var result = a + b;
      my_add.cache[cache_key] = result;

      return result;

    }

The above could have used the json string of arguments as a cache key

     var cachekey = JSON.stringify(Array.prototype.slice.call(arguments)),



##### Configuration Objects (umm.. hash passed as argument?)

    var conf = {
     username: "batman",
     first: "Bruce",
     last: "Wayne"
    };
    addPerson(conf);

>
The pros of the configuration objects are:
* No need to remember the parameters and their order
* You can safely skip optional parameters
* Easier to read and maintain
* Easier to add and remove parameters
The cons of the configuration objects are:
* You need to remember the names of the parameters
* Property names cannot be minified



##### Namespace Pattern

    var MYAPP = {};
    MYAPP.Parent = function () {};
    MYAPP.some_var = 1;
    MYAPP.modules = {};
    MYAPP.modules.module1 = {};

Checking if namespace exists (maybe at time of library file)

    var MYAPP = MYAPP || {};

Build a namespace function that will autovivify, or maybe one exists already

##### Declaring Dependencies

>
It's a good idea to declare the modules your code relies on at the top of your
function or module. The declaration involves creating only a local variable and
pointing to the desired module: _(I don't know about doing this at function
level)

    var myFunction = function () {
      var event = YAHOO.util.Event,
      dom = YAHOO.util.Dom;
      //... 
    };


Private Members are easy, use closure

    function MyConstructor( data ) {

      var data = data;

      this.get_data = function() {
        return data
      }

    }

    var obj = new MyConstructor(123);
    log(obj.get_data()); //=> 123

Warning:  if you return a reference (like an array, object) then that can be
modified outside the object - instead return a clone.


To create private data with an object literal you need to wrap with immediate function.

    var obj = ( function() {

      var data = 123;

      return {
        get_data: function(){ return data }
      }

    } )();

    log(obj.get_data()); //=> 123


My example of implementing class variable


    function MyConstructor() {}

    MyConstructor.prototype = ( function() {

      var count = 0;

      return {
        increment: function() {
          log("incrementing " + count);
          count++
        },
        get_count: function() {
          return count
        }
      }

    } )()


    for ( var i = 0, a = []; i < 5; i++ ) {
      ( new MyConstructor ).increment();
    }

    log( ( new MyConstructor ).get_count() )



##### Revelation Pattern (paranoid much?)


    var myParanoidObj = ( function() {

      function func1() { log( 'in func1' ) }

      function func2() { func1() } // calls func1

      return {
        func1: func1,
        func2: func2,
      }

    } )()

    myParanoidObj.func1(); //=> in func1
    myParanoidObj.func2(); //=> in func1

    myParanoidObj.func1 = null
    myParanoidObj.func1(); //=> TypeError not a function
    myParanoidObj.func2(); //=> in func1 (still works!)


##### Module Pattern

>
* Namespaces
* Immediate functions
* Private and privileged members
* Declaring dependencies


Create namespace

    MYAPP = {};
    MYAPP.utilities = {}
    MYAPP.utilities.array = {}

Define module and public methods

    MYAPP.utilities.array = ( function() {

      // methods
      inArray: function( needle, haystack ) { };
      isArray: function( a ) { };

      // reveal public methods
      return {
        inArray: inArray,
        isArray: isArray,
      };

    }() );


Constructor version:

    var MYAPP = {};
    MYAPP.utilities = {};

    MYAPP.utilities.Array = ( function() {

      // ... private methods and data

      function Constructor() {};

      Constructor.prototype = {
        inArray: function( needle, haystack ) {},
        isArray: function( a ) {},
      }

      return Constructor;

    }() );


    var obj = new MYAPP.utilities.Array



##### Public Static Method

    var MyConstructor = function(){}
    MyConstructor.static = function(){ log("I'm static") }
    MyConstructor.static()


##### Private static data


    var MyConstructor = ( function() {

      var counter = 0;

      return function(){ // this is what gets 'new'
        log(counter++)
      }

    } )()

    new MyConstructor; //=> 1
    new MyConstructor; //=> 2
    new MyConstructor; //=> 3


##### Private static method


    var MyConstructor = ( function() {

      var counter = 0;
      var InternalConstructor = function(){
        counter = counter + 1;
        log(counter) 
      };

      InternalConstructor.prototype.getCount = function() {
        return counter
      };

      return InternalConstructor;

    } )()

    new MyConstructor; //=> 1
    new MyConstructor; //=> 2
    new MyConstructor; //=> 3

    var obj = new MyConstructor; //=> 4
    log( obj.getCount() ) //=> 4


##### Chaining methods pattern

>
When you create __methods that have no meaningful return value__, you can have
them return this, the instance of the object they are working with. This will
enable consumers of that object to call the next method chained to the
previous:

    var Constructor = function() {

      this.count = 0;

      this.add = function( x ) {
        this.count = this.count + x;
        return this;
      };

      this.get = function() {
        return this.count
      }

    }

    var o = new Constructor;
    log( o.add( 1 ).add( 5 ).get() ) //=> 6




In ECMAScript 5, the prototypal inheritance pattern becomes officially a part
of the language. This pattern is implemented through the method
Object.create(). 

    var child = Object.create(parent);

#### Design Patterns


##### Singleton


My attempt at a singleton:

    var Universe = ( function() {

      var cache;

      return function() { // actual constructor

        if ( cache ) {
          return cache;
        } else {
          cache = this;
        }

      }

    } )()

    log( new Universe === new Universe ) //=> true


##### Factory

_too easy_


##### Built in object factor


    var o = new Object(),
        n = new Object(1),
        s = Object('1'),
        b = Object(true);

    o.constructor === Object; // true
    n.constructor === Number; // true
    s.constructor === String; // true
    b.constructor === Boolean; // true

>
The fact that Object() is also a factory is of _little practical use_, just
something worth mentioning as an example that the factory pattern is all around
us


##### Revisit the following patterns

Figure out simplier implementations then the tedious ones offered in this book.

Decorator
Strategy
Facade
Proxy
Mediator
Observer

_Skipping Dom Stuff, better left for other books_


## Ember Guides and Tutorials

__Ember's switch to ember-cli has broken pretty much all documentation and tutorials
on the entire internet, trying to slog through this mess__

### Setup


much of the configs comes from here

    http://ember.vicramon.com/creating-the-rails-api


#### Rails Backend Steps

    gem update
    rails new backend --database=mysql --skip-turbolinks 
    cd backend

    # in Gemfile
    gem 'active_model_serializers'
    gem 'ffaker' # in development group
    bundle update

    rails g model lead
    rails g serializer lead
    rails g controller api/v1/leads



#### Ember Frontend Steps
 
    npm update -g
    ember new frontend --skip-git
    cd frontend
    ember install:addon ember-cli-emblem-hbs-printer

    # in .ember-cli (I don't know why this wasn't necessary this last time)
    "liveReload": true,
    "watcher": "polling"


### The Object Model

#### Classes and Instances

>
To define a new Ember __class__, use extend(), to create object from that class
use create()

    var app_person = Ember.Object.extend( {
      say: function( thing ) {
        alert( thing );
      }
    } );

    app_person.create().say( 'something' ); //=> box 'something'

You can create a subclass of an existing class with extend

    var myClass = Ember.Object.extend( {
      say: function( thing ) {
        alert( thing );
      }
    } );

    var mySubClass = myClass.extend();
    mySubClass.create().say('something else'); //=> box 'something else'

Can access the superclass with this._super

    var myClass = Ember.Object.extend( {
      say: function( thing ) {
        alert( 'myClass' );
      }
    } );

    var mySubClass = myClass.extend({
      say: function( thing ) {
        this._super(); //<---- HERE
        alert( 'mySubClass' );
      }
    });

    mySubClass.create().say('something else'); //=> boxs 'myClass'...'mySubClass'



Initialize new object by passing in a 'hash'

    var myClass = Ember.Object.extend( {
      name: '',
      say: function( thing ) {
        alert( this.get('name') );
      }
    } );

    var myObj = myClass.create({name:'kevin'}); 
    myObj.say();

>
For performance reasons, note that you cannot redefine an instance's computed
properties or methods when calling create(), nor can you define new ones. You
should only set simple properties when calling create(). If you need to define
or redefine methods or computed properties, create a new subclass and
instantiate that.

>
If you are subclassing a framework class, like Ember.View or
Ember.ArrayController, and you override the init method, make sure you call
this._super()! If you don't, the system may not have an opportunity to do
important setup work, and you'll see strange behavior in your application.

    var myClass = Ember.Object.extend( {
      init: function(){
        alert('init');
      },
      say: function( thing ) {
        alert( this.get('name') );
      }
    } );

    var myObj = myClass.create({name:'kevin'}); 
    myObj.say();

>
When accessing the properties of an object, use the get and set accessor
methods. Make sure to use these accessor methods; otherwise, __computed
properties won't recalculate, observers won't fire, and templates won't
update.__



#### Computed Properties

This example isn't that great because it doesn't show templates and other computed
properties being updated.  This example also shows chaining.  Note that .property()
method on function prototype makes function accessible with get('myfunction') and also
wires up functin to be dynamic when properties it depends on change.

    var myClass = Ember.Object.extend( {
      firstName: 'bob',
      lastName: 'smith',
      age: 45,
      fullName: function() {
        return this.get( 'firstName' ) + ' ' + this.get( 'lastName' );
      }.property( 'firstName', 'lastName' ),
      description: function() {
        return [ this.get( 'fullName' ), this.get( 'age' ) ].join( ' ' );
      }.property( 'firstName', 'lastName', 'age' ),
    } );

    var obj = myClass.create();
    log( obj.get( 'description' ) ); //=> bob smith 45



>
Ember will call the computed property for both setters and getters, __so if you
want to use a computed property as a setter, you'll need to check the number of
arguments to determine whether it is being called as a getter or a setter.__
Note that __if a value is returned from the setter, it will be cached as the
property's value.__

    App.Person = Ember.Object.extend({
      firstName: null,
      lastName: null,

      fullName: function(key, value) {
        // setter
        if (arguments.length > 1) { //<--- HERE
          var nameParts = value.split(/\s+/);
          this.set('firstName', nameParts[0]);
          this.set('lastName',  nameParts[1]);
        }

        // getter
        return this.get('firstName') + ' ' + this.get('lastName');
      }.property('firstName', 'lastName')
    });


    var captainAmerica = App.Person.create();
    captainAmerica.set('fullName', "William Burnside");
    captainAmerica.get('firstName'); // William
    captainAmerica.get('lastName'); // Burnside



#### Observers




## You Don't Know JS

>
this is actually a binding that is made when a function is invoked, and what it
references is determined entirely by the call-site where the function is
called.
* Called with new?  Use the newly constructed object.
* Called with call or apply (or bind)? Use the specified object.
* Called with a context object owning the call? Use that context object.
* Default: undefined in strict mode, global object otherwise.

----

#### Explicit <i>this</i> binding
>
With respect to this binding, call(..) and apply(..) are identical. They do
behave differently with their additional parameters, but that’s not something
we care about presently.

#### Hard <i>this</i> binding in ES5

    var bar = foo.bind( obj );

>
Many libraries’ functions, and indeed many new built-in functions in the
JavaScript language and host environment, provide an optional parameter,
usually called “context,” which is designed as a work- around for you not
having to use bind(..) to ensure your callback function uses a particular this.

    [1, 2, 3].forEach( foo, obj );


#### New <i>this</i> binding

>
When a function is invoked with new in front of it, otherwise known as a
constructor call, the following things are done automatically:
1. A brand new object is created (aka constructed) out of thin air.
2. The newly constructed object is [[Prototype]]-linked.
3. The newly constructed object is set as the this binding for that function call.
4. Unless the function returns its own alternate object, the new invoked
function call will automatically return the newly constructed object.


#### Create DMZ object for passing 'null' to call, apply, bind

ø is typed with opt-o on mac

    var ø = Object.create( null );
    var bar = foo.bind( ø, 2 );

#### get and set


    var obj = {
      get x() { return this._x },
      set x( x ) { this._x = x }
    }
