require 'rails_helper'

RSpec.describe Task, :type => :model do


  it "can distinguish a completed task" do
    task = Task.new
    expect(task).not_to be_complete
    task.mark_completed
    expect(task).to be_complete
  end



end
