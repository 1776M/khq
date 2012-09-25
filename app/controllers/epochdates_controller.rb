class EpochdatesController < ApplicationController

     before_filter :signed_in_user, :only => [:index, :edit, :update, :destroy]
     before_filter :correct_user, :only => [:edit, :update, :destroy]

  def show
      @epochdate = Epochdate.find(params[:id])
      @group = @epochdate.scenario.project.user.group
      @basecase = Basecase.find(:last, :conditions => [" group_id = ?", @group.id])
  end

  def create
    @scenario = Scenario.find(params[:scenario_id])    
    @epochdate = @scenario.epochdates.build(params[:epochdate])
    if @epochdate.save
      flash[:success] = "You have created new data"
      redirect_to scenario_path(@epochdate.scenario.id)
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit 
      @epochdate = Epochdate.find(params[:id]) 
      @title = "Edit data" 
  end

  def update
    @epochdate = Epochdate.find(params[:id])
    if @epochdate.update_attributes(params[:epochdate])
      flash[:success] = "Data updated"
      redirect_to scenario_path(@epochdate.scenario_id)
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @epochdates = Epochdate.all
  end

  def destroy
    Epochdate.find(params[:id]).destroy
    flash[:success] = "Data deleted"
    if current_user.name == 'mandeep3'     
        redirect_to scenario_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @epochdate = Epochdate.find(params[:id])
      @user = @epochdate.scenario.project.user
      redirect_to(root_path) unless current_user?(@user)
    end


end
