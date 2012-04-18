class BasecasesController < ApplicationController

    before_filter :authorized_admin, :only => [:show] 
    before_filter :authorized_group_member, :only => [:show]
    

  def show
     @basecase = Basecase.find(params[:id])
     # @basecase = Basecase.new if signed_in?
     @annuals = @basecase.annuals
     @annual = Annual.new if signed_in?
     @rules = @basecase.rules
     @rule = Rule.new if signed_in?      
     @borrowings = @basecase.borrowings
     @borrowing = Borrowing.new if signed_in?
     @total_debt = @basecase.total_debt(params[:id])
     @fixed_percent = @basecase.fixed_percent(params[:id])
     @currency_percent = @basecase.total_debt(params[:id]).group_by{|c| c.currency }
     @float_percent = @basecase.total_debt(params[:id]).group_by{|c| c.fixed_float }
     @maturity_percent = @basecase.total_debt(params[:id]).group_by{|c| c.maturity_year - c.issue_year }
     @reset_percent = @basecase.total_debt(params[:id]).group_by{|c| c.maturity_year - Time.now.year }
     # this it to add show the cholesky 
     # @cholesky = Cholesky.find(:all)
     # @choleskyir = Choleskyir.find(:all)
     # @forwardcurve = Forwardcurve.find(:all)       
  end

  def create
      @group = Group.find(params[:group_id])    
      @basecase = @group.basecases.build(params[:basecase]) 
    if @basecase.save
      flash[:success] = "Basecase created!"
      redirect_to groups_path
    else
      render groups_path
    end
  end

  def destroy
    Basecase.find(params[:id]).destroy
    flash[:success] = "Basecase deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to group_path(current_user.group_id)
    end

  end

  private

      def authorized_admin
          @basecase = Basecase.find(params[:id])
          @group = @basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @basecase = Basecase.find(params[:id])
          @group = @basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
