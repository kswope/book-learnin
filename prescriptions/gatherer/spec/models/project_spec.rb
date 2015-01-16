require 'rails_helper'


RSpec.describe "Something" do

 describe Project, :type => :model do

    it 'one considers a project with no tasks to be done' do
      project = Project.new
      expect(project.done?).to be_truthy
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
