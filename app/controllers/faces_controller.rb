class FacesController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @face = Face.find(params[:id])
  end

  def create
    @dashboard = Dashboard.find(params[:dashboard_id])    
    @face = @dashboard.faces.build(params[:face])
    if @face.save
      flash[:success] = "You have created a new tab"
      redirect_to dashboard_path(@face.dashboard_id)
    else
      render 'new'
    end
  end

  def edit 
      @face = Face.find(params[:id]) 
  end

  def update
    @face = Face.find(params[:id])
    if @face.update_attributes(params[:face])
      flash[:success] = "Tab updated"
      redirect_to face_path(@face.dashboard_id)
    else
      @title = "Edit tab"
      render 'edit'
    end
  end
 
  def index
    @faces = Face.all
  end

  def destroy
    Face.find(params[:id]).destroy
    flash[:success] = "Tab deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

      def authorized_admin
          @face = Face.find(params[:id])
          @group = @face.dashboard.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @face = Face.find(params[:id])
          @group = @face.dashboard.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
