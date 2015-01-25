#!/usr/bin/env ruby

# scratch area for rspec experiments without rails

# run with
# $ rspec -c rspec.rb



class Calculator


  def add(*args)
    args.inject(:+)
  end


end


# it multi expectations style
RSpec.context Calculator do

  before(:each) do
    @calc = Calculator.new
  end

  it 'should be able to add two numbers together' do
    expect( @calc.add(1,1) ).to eql(2)
    expect( @calc.add(3,1) ).to eql(4)
    expect( @calc.add(5,1) ).not_to eql(0)
  end

  it 'add 1 to 1 = 2' do
    expect( @calc.add(1,1) ).to eql(2)
  end

end



# specify style
RSpec.describe Calculator do

  let(:calc){ Calculator.new }

  describe 'using add with 2 params' do
    specify { expect( calc.add(1,1) ).to eql(2) }
    specify { expect( calc.add(2,3) ).to eql(5) }
    specify { expect( calc.add(8,9) ).to eql(17) }
  end

  context 'using add with 3 params' do
    specify { expect( calc.add(1,1,1) ).to eql(3) }
    specify { expect( calc.add(2,3,4) ).to eql(9) }
    specify { expect( calc.add(8,9,1) ).to eql(18) }
  end


end
