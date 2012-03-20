class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    if current_user.name == 'mandeep3'     
        redirect_to groups_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @group = Group.find(params[:group_id])    
    @user = @group.users.build(params[:user])
    if params[:user][:admin]==true 
        @user.admin=true
    end
    if @user.save
      # sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to groups_path
    else
      redirect_to group_path(@group.id)
    end
  end 

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

   private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?  || current_user.name == 'mandeep3'
    end

end
