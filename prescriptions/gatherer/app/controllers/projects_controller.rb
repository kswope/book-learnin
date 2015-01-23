class ProjectsController < ApplicationController


  def new
    @project = Project.new
  end


  def create

    redirect_to projects_path

  end






end
