class LookupsController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @lookup = Lookup.find(params[:id])
  end

  def create
    @basecase = Basecase.find(params[:basecase_id])    
    @lookup = @basecase.lookups.build(params[:lookup])
    if @lookup.save
      flash[:success] = "You have created new data"
      redirect_to basecase_path(@lookup.basecase_id)
    else
      render 'new'
    end
  end

  def edit 
      @lookup = Lookup.find(params[:id]) 
  end

  def update
    @lookup = Lookup.find(params[:id])
    if @lookup.update_attributes(params[:lookup])
      flash[:success] = "Data updated"
      redirect_to @lookup
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @lookups = Lookup.all
  end

  def destroy
    Lookup.find(params[:id]).destroy
    flash[:success] = "Data deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

      def authorized_admin
          @lookup = Lookup.find(params[:id])
          @group = @lookup.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @lookup = Lookup.find(params[:id])
          @group = @lookup.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
