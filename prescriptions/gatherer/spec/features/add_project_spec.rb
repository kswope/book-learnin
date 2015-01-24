
require 'rails_helper'

describe 'adding projects' do

  it "allows a user to create a project with tasks" do

    visit new_project_path 
    fill_in "Name", with: "Project Runway"
    fill_in "Tasks", with: "Task 1:3\nTask 2:5"
    click_on("Create Project")
    clog
    # visit projects_path
    # expect(page).to have_content("Project Runway")
    # expect(page).to have_content("8")

  end

end

