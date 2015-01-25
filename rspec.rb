#!/usr/bin/env ruby

# scratch area for rspec experiments without rails

# run with
# $ rspec -c rspec.rb


class Members

  attr_accessor :members

  def initialize(members_array)
    self.members = members_array
  end

  def has_member?(m)
    members.include?(m)
  end

end



RSpec.describe Members do


  context 'knows what members it has' do

    let(:members) { Members.new([:one, :two, :three]) }

    specify{ expect(members).to have_member(:one) }
    specify{ expect(members).to have_member(:two) }
    specify{ expect(members).to have_member(:three) }
    specify{ expect(members).not_to have_member(:four) }

  end

end
