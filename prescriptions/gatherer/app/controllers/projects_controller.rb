class ProjectsController < ApplicationController


  def new
    @project = Project.new
  end


  def create

    @action = CreatesProject.new(name: params[:project][:name],
                                 task_string: params[:project][:tasks])

    if @action.create
      redirect_to projects_path
    else
      @project = @action.project
      render :new
    end

  end






end
