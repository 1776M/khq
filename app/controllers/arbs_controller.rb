class ArbsController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @arb = Arb.find(params[:id])
  end

  def create
    @basecase = Basecase.find(params[:basecase_id])    
    @arb = @basecase.arbs.build(params[:arb])
    if @arb.save
      flash[:success] = "You have created new data"
      redirect_to basecase_path(@arb.basecase_id)
    else
      render 'new'
    end
  end

  def edit 
      @arb = Arb.find(params[:id]) 
  end

  def update
    @arb = Arb.find(params[:id])
    if @arb.update_attributes(params[:arb])
      flash[:success] = "Data updated"
      redirect_to @arb
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @arbs = Arb.all
  end

  def destroy
    Arb.find(params[:id]).destroy
    flash[:success] = "Data deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

      def authorized_admin
          @arb = Arb.find(params[:id])
          @group = @arb.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @arb = Arb.find(params[:id])
          @group = @arb.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
