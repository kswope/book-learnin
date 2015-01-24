class ProjectsController < ApplicationController


  def new
    @project = Project.new
  end


  def create

    @action = CreatesProject.new( name: params[:project][:name], task_string: params[:project][:tasks])
    @action.create
    redirect_to projects_path

  end






end
