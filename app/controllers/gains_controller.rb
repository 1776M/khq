class GainsController < ApplicationController

     before_filter :signed_in_user, :only => [:index, :edit, :update, :destroy]
     before_filter :correct_user, :only => [:edit, :update, :destroy]

  def show
      @gain = Gain.find(params[:id])
      @group = @gain.scenario.project.user.group
      @basecase = Basecase.find(:last, :conditions => [" group_id = ?", @group.id])
  end

  def create
    @scenario = Scenario.find(params[:scenario_id])    
    @gain = @scenario.gains.build(params[:gain])
    if @gain.save
      flash[:success] = "You have created new data"
      redirect_to scenario_path(@gain.scenario.id)
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit 
      @gain = Gain.find(params[:id]) 
      @title = "Edit data" 
  end

  def update
    @gain = Gain.find(params[:id])
    if @gain.update_attributes(params[:gain])
      flash[:success] = "Data updated"
      redirect_to scenario_path(@gain.scenario_id)
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @gains = Gain.all
  end

  def destroy
    Gain.find(params[:id]).destroy
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
      @gain = Gain.find(params[:id])
      @user = @gain.scenario.project.user
      redirect_to(root_path) unless current_user?(@user)
    end


end
