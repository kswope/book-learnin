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
- [Metaprogramming Ruby](#metaprogramming-ruby)
- [Pickaxe Part I Ruby.new](#pickaxe-part-i-rubynew)
- [Pickaxe Part III Ruby Crystalized](#pickaxe-part-iii-ruby-crystalized)
- [The Well Grounded Rubyist](#the-well-grounded-rubyist)


TODO

- Well Grounded Rubyist
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

Ruby has a lot of built-in classes. Most of them can be instantiated using new:

    str = String.new
    arr = Array.new


Some can’t; for example, you can’t create a new instance of the class
__Integer__.  But for the most part, you can create new instances of the
built-in classes.

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


page 187
