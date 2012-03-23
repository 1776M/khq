class ProjectsController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy, :show]
  before_filter :authorized_user, :only => :destroy


  def show
     @project = current_user.projects.find(params[:id])
     # @scenarios = @project.scenarios
     # @scenario = Scenario.new if signed_in?
     # this it to add show the cholesky 
     # @cholesky = Cholesky.find(:all)
     # @choleskyir = Choleskyir.find(:all)
     # @forwardcurve = Forwardcurve.find(:all)           
  end

  def create
      @project  = current_user.projects.build(params[:project])
    if @project.save
      flash[:success] = "Project created!"
      redirect_to user_path(current_user)
    else
      render user_path(current_user)
    end
  end

  def destroy
    @project.destroy
    redirect_back_or user_path(current_user)
  end

  private

    def authorized_user
      @project = Project.find(params[:id])
      redirect_to root_path unless current_user?(@project.user)
    end


end
