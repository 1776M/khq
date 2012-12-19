class SensesController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @sense = Sense.find(params[:id])
  end

  def create
    @face = Face.find(params[:face_id])    
    @sense = @face.senses.build(params[:sense])
    if @sense.save
      flash[:success] = "You have created a new tab"
      redirect_to face_path(@sense.face_id)
    else
      render 'new'
    end
  end

  def edit 
      @sense = Sense.find(params[:id]) 
  end

  def update
    @sense = Sense.find(params[:id])
    if @sense.update_attributes(params[:sense])
      flash[:success] = "Tab updated"
      redirect_to sense_path(@sense.face_id)
    else
      @title = "Edit tab"
      render 'edit'
    end
  end
 
  def index
    @senses = Sense.all
  end

  def destroy
    Sense.find(params[:id]).destroy
    flash[:success] = "Tab deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end

  
  private

      def authorized_admin
          @sense = Sense.find(params[:id])
          @group = @sense.face.dashboard.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @sense = Sense.find(params[:id])
          @group = @sense.face.dashboard.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end