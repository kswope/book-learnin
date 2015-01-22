require 'rails_helper'

require 'pp'

RSpec.describe "Something" do

 describe Project, :type => :model do

    it 'identity' do

      puts expect(true)
      puts eq(3)
      puts be_truthy 
      puts be
      puts be(3)

      puts expect(3).to eq(3)
      puts expect(3).to be_truthy
      expect(3).to eq(3)
    end

    it('') do
      project = Project.new
      expect(project.done?).to be_truthy
    end

    specify do
      project = Project.new
      expect(project.done?).to be_truthy
    end

  end
end
