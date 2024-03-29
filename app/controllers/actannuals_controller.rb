class ActannualsController < ApplicationController

     before_filter :signed_in_user, :only => [:index, :edit, :update, :destroy]
     before_filter :correct_user, :only => [:edit, :update, :destroy]

  def show
      @actannual = Actannual.find(params[:id])
      @actcurrency_new = Actcurrency.new if signed_in?
      @actcurrencies = @actannual.actcurrencies
      @group = @actannual.scenario.project.user.group
      @basecase = Basecase.find(:last, :conditions => [" group_id = ?", @group.id])
      @annuals = Annual.find(:all, :conditions => [" basecase_id = ?", @basecase.id])
      @currencies =  Currency.find(:all, :conditions => [" annual_id = ?", @actannual.top_annual])
  end

  def create
    @scenario = Scenario.find(params[:scenario_id])    
    @actannual = @scenario.actannuals.build(params[:actannual])
    if @actannual.save
      flash[:success] = "You have created new data"
      redirect_to scenario_path(@actannual.scenario.id)
    else
      @title = "Sign up"
      render 'new'
    end

    @annual = Annual.find(@actannual.top_annual)
    @currencies = @annual.currencies

    params = Hash.new  
    @currencies.each do |currency|
      unless @actannual.top_annual.nil? || @actannual.top_annual ==""

        params[:actcurrency] = {
     
             currency_name: currency.currency_name,
             year_0: currency.year_0,
             year_1: currency.year_0,
             year_2: currency.year_0,
             year_3: currency.year_0,
             year_4: currency.year_0,
             year_5: currency.year_0,            
             actannual_id: @actannual.id,
  
             }

        @actcurrency = @actannual.actcurrencies.build(params[:actcurrency])
        if @actcurrency.save
          # this is just a dummy variable to do something in the loop
          a = 1
        end   
      end
    end   
  end

  def edit 
      @actannual = Actannual.find(params[:id]) 
      @title = "Edit data" 
  end

  def update
    @actannual = Actannual.find(params[:id])
    if @actannual.update_attributes(params[:actannual])
      flash[:success] = "Data updated"
      redirect_to scenario_path(@actannual.scenario_id)
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @actannuals = Actannual.all
  end

  def destroy
    Actannual.find(params[:id]).destroy
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
      @actannual = Actannual.find(params[:id])
      @user = @actannual.scenario.project.user
      redirect_to(root_path) unless current_user?(@user)
    end


end
