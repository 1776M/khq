class ScenariosController < ApplicationController

     before_filter :signed_in_user, :only => [:index, :edit, :update, :destroy]
     before_filter :correct_user, :only => [:edit, :update, :destroy]    

  def show
     @scenario = Scenario.find(params[:id])
     # @scenario = scenario.new if signed_in?
     @actannuals = @scenario.actannuals
     @actannual = @scenario.actannuals.find(:last) #Actannual.new if signed_in?
     @actannual_new = Actannual.new if signed_in?    
     @actborrowings = @scenario.actborrowings
     @actborrowing_new = Actborrowing.new if signed_in?
     @group = @scenario.project.user.group
     @basecase = Basecase.find(:last, :conditions => [" group_id = ?", @group.id])
     @annual =  Annual.find(:last, :conditions => [" basecase_id = ?", @basecase.id])
     @annuals =  Annual.find(:all, :conditions => [" basecase_id = ?", @basecase.id])
     @borrowings =  Borrowing.find(:all, :conditions => [" basecase_id = ?", @basecase.id])
     @total_debt = @scenario.total_debt(params[:id])
     @fixed_percent = @scenario.fixed_percent(params[:id])
     @currency_percent = @scenario.total_debt(params[:id]).group_by{|c| c.currency }
     @float_percent = @scenario.total_debt(params[:id]).group_by{|c| c.fixed_float }
     @maturity_percent = @scenario.total_debt(params[:id]).group_by{|c| c.maturity_year - c.issue_year }
     @reset_percent = @scenario.total_debt(params[:id]).group_by{|c| c.maturity_year - Time.now.year }
     @fxrate = Fxrate.find(:all)
     @forwardcurve = Forwardcurve.find(:all)
  end

  def create
      @project = Project.find(params[:project_id])    
      @scenario = @project.scenarios.build(params[:scenario]) 
    if @scenario.save
      flash[:success] = "scenario created!"
      redirect_to project_path(params[:project_id])
    else
      render user_path(current_user)
    end
  end

  def destroy
    Scenario.find(params[:id]).destroy
    flash[:success] = "scenario deleted"
    if current_user.name == 'mandeep3'     
        redirect_to groups_path
    else
        redirect_to group_path(current_user.group_id)
    end

  end

  def filter
   @scenario = Scenario.find(:all) 
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @scenario = Scenario.find(params[:id])
      @user = @scenario.project.user
      redirect_to(root_path) unless current_user?(@user)
    end


end
