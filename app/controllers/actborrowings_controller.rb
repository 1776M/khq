class ActborrowingsController < ApplicationController

     before_filter :signed_in_user, :only => [:index, :edit, :update, :destroy]
     before_filter :correct_user, :only => [:edit, :update, :destroy]

  def show
      @actborrowing = Actborrowing.find(params[:id])
  end

  def create
    @scenario = Scenario.find(params[:scenario_id])    
    @actborrowing = @scenario.actborrowings.build(params[:actborrowing])
    if @actborrowing.save
      flash[:success] = "You have created new data"
      redirect_to project_path(@actborrowing.scenario.project.id)
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit 
      @actborrowing = Actborrowing.find(params[:id]) 
      @title = "Edit data" 
  end

  def update
    @actborrowing = Actborrowing.find(params[:id])
    if @actborrowing.update_attributes(params[:actborrowing])
      flash[:success] = "Data updated"
      redirect_to scenario_path(@actborrowing.scenario_id)
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @actborrowings = Actborrowing.all
  end

  def destroy
    Actborrowing.find(params[:id]).destroy
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
      @actborrowing = Actborrowing.find(params[:id])
      @user = @actborrowing.scenario.project.user
      redirect_to(root_path) unless current_user?(@user)
    end


end
