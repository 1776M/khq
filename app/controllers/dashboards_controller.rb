class DashboardsController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @dashboard = Dashboard.find(params[:id])
  end

  def create
    @basecase = Basecase.find(params[:basecase_id])    
    @dashboard = @basecase.dashboards.build(params[:dashboard])
    if @dashboard.save
      flash[:success] = "You have created a new dashboard"
      redirect_to basecase_path(@dashboard.basecase_id)
    else
      render 'new'
    end
  end

  def edit 
      @dashboard = Dashboard.find(params[:id]) 
  end

  def update
    @dashboard = Dashboard.find(params[:id])
    if @dashboard.update_attributes(params[:dashboard])
      flash[:success] = "Dashboard updated"
      redirect_to basecase_path(@dashboard.basecase_id)
    else
      @title = "Edit dashboard"
      render 'edit'
    end
  end
 
  def index
    @dashboards = Dashboard.all
  end

  def destroy
    Dashboard.find(params[:id]).destroy
    flash[:success] = "Dashboard deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

      def authorized_admin
          @dashboard = Dashboard.find(params[:id])
          @group = @dashboard.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @dashboard = Dashboard.find(params[:id])
          @group = @dashboard.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
