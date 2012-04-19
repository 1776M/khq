class InputsController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @input = Input.find(params[:id])
  end

  def create
    @basecase = Basecase.find(params[:basecase_id])    
    @input = @basecase.inputs.build(params[:input])
    if @input.save
      flash[:success] = "You have created new data"
      redirect_to basecase_path(@input.basecase_id)
    else
      render 'new'
    end
  end

  def edit 
      @input = Input.find(params[:id]) 
  end

  def update
    @input = Input.find(params[:id])
    if @input.update_attributes(params[:input])
      flash[:success] = "Data updated"
      redirect_to @input
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @inputs = Input.all
  end

  def destroy
    Input.find(params[:id]).destroy
    flash[:success] = "Data deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

      def authorized_admin
          @input = Input.find(params[:id])
          @group = @input.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @input = Input.find(params[:id])
          @group = @input.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
