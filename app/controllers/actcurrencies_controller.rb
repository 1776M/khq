class ActcurrenciesController < ApplicationController

     before_filter :signed_in_user, :only => [:index, :edit, :update, :destroy]
     before_filter :correct_user, :only => [:edit, :update, :destroy]

  def show
      @actcurrency = Actcurrency.find(params[:id])
  end

  def create
    @actannual = Actannual.find(params[:actannual_id])    
    @actcurrency = @actannual.actcurrencies.build(params[:actcurrency])
    if @actcurrency.save
      flash[:success] = "You have created new data"
      redirect_to actannual_path(@actcurrency.actannual_id)
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit 
      @actcurrency = Actcurrency.find(params[:id]) 
  end

  def update
    @actcurrency = Actcurrency.find(params[:id])
    if @actcurrency.update_attributes(params[:actcurrency])
      flash[:success] = "Data updated"
      redirect_to actannual_path(@actcurrency.actannual_id)
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @actcurrencies = Actcurrency.all
  end

  def destroy
    Actcurrency.find(params[:id]).destroy
    flash[:success] = "Data deleted"
    if current_user.name == 'mandeep3'     
        redirect_to actannual_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @actcurrency = Actcurrency.find(params[:id])
      @user = @actcurrency.actannual.scenario.project.user
      redirect_to(root_path) unless current_user?(@user)
    end

end
