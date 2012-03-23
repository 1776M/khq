class GroupsController < ApplicationController

  before_filter :authorized_superadmin, :only => [:index] 
  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def new
      @group = Group.new
      @title = "New group"
  end

  def show
      @group = Group.find(params[:id])
      @users = @group.users
      @basecases = @group.basecases
      @user = User.new if signed_in?
      @basecase = Basecase.new if signed_in? 
  end

  def create
    @group = Group.new(params[:group])
    if @group.save 
      flash[:success] = "You have created a new group"
      redirect_to @group
    else
      @title = "New group"
      render 'new'
    end
  end

  def edit
      @group = Group.find(params[:id])  
      @title = "Edit group" 
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:success] = "Group updated"
      redirect_to @group
    else
      @title = "Edit group"
      render 'edit'
    end
  end
 
  def index
    @title = "All groups"
    @groups = Group.all
  end

  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "Group deleted"
    redirect_to groups_path
  end

  private

      def authorized_superadmin
          redirect_to root_path unless current_user_superadmin(current_user)
      end

      def authorized_admin
          @group = Group.find(params[:id])
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @group = Group.find(params[:id]) 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')
      end
end
