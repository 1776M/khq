class CurrenciesController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @currency = Currency.find(params[:id])
  end

  def create
    @annual = Annual.find(params[:annual_id])    
    @currency = @annual.currencies.build(params[:currency])
    if @currency.save
      flash[:success] = "You have created new data"
      redirect_to annual_path(@currency.annual_id)
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit 
      @currency = Currency.find(params[:id]) 
  end

  def update
    @currency = Currency.find(params[:id])
    if @currency.update_attributes(params[:currency])
      flash[:success] = "Data updated"
      redirect_to annual_path(@currency.annual_id)
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @currencies = Currency.all
  end

  def destroy
    Currency.find(params[:id]).destroy
    flash[:success] = "Data deleted"
    if current_user.name == 'mandeep3'     
        redirect_to annual_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

      def authorized_admin
          @currency = Currency.find(params[:id])
          @group = @currency.annual.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @currency = Currency.find(params[:id])
          @group = @currency.annual.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
