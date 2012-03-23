class BorrowingsController < ApplicationController

    before_filter :authorized_admin, :only => [:show] 
    before_filter :authorized_group_member, :only => [:show]

  def show
      @borrowing = Borrowing.find(params[:id])
  end

  def create
    @basecase = Basecase.find(params[:basecase_id])    
    @borrowing = @basecase.borrowings.build(params[:borrowing])
    if @borrowing.save
      flash[:success] = "You have created new data"
      redirect_to basecase_path(@borrowing.basecase_id)
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit 
      @borrowing = Borrowing.find(params[:id]) 
      @title = "Edit data" 
  end

  def update
    @borrowing = Borrowing.find(params[:id])
    if @borrowing.update_attributes(params[:borrowing])
      flash[:success] = "Data updated"
      redirect_to @borrowing
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @borrowings = Borrowing.all
  end

  def destroy
    @basecase = Borrowing.find(params[:id]).basecase
    Borrowing.find(params[:id]).destroy
    flash[:success] = "Data deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        # redirect_to group_path(current_user.group_id)
        redirect_to basecase_path(@basecase.id)
        
    end
  end
  
  private

      def authorized_admin
          @borrowing = Borrowing.find(params[:id])
          @group = @borrowing.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @borrowing = Borrowing.find(params[:id])
          @group = @borrowing.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
