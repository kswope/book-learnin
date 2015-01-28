
# my experiments with the composite pattern 
# get() is the common behavior
# run with rspec

require 'pp'


class Component # common interface for leaf and composite

  attr_accessor :data

  def initialize(*args)
    self.data = args
  end

end

class Leaf < Component

  def get
    data
  end

end

class Composite < Component

  def get(data=self.data, accum=[])

    data.each do |element|
      _get(element,accum) if element.is_a?(Composite)
      accum << element.data
    end

    accum

  end

end


RSpec.context do

  let(:composite) do
    Composite.new( Leaf.new(1,2,3), Leaf.new(4,5,6), Leaf.new(7,8,9))
  end

  let(:leaf) do
    Leaf.new(1,2,3)
  end

  specify do
    expect(composite.data.map(&:data)).to eq([[1,2,3],[4,5,6],[7,8,9]])
  end

  specify do
    expect(leaf.data).to eq([1,2,3])
  end

  specify do
    expect(composite.get).to eq([[1,2,3],[4,5,6],[7,8,9]])
  end

  specify do
    expect(leaf.get).to eq([1,2,3])
  end

end





