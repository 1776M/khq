class RulesController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @rule = Rule.find(params[:id])
  end

  def create
    @basecase = Basecase.find(params[:basecase_id])    
    @rule = @basecase.rules.build(params[:rule])
    if @rule.save
      flash[:success] = "You have created new rule"
      redirect_to basecase_path(@rule.basecase_id)
    else
      render 'new'
    end
  end

  def edit 
      @rule = Rule.find(params[:id]) 
  end

  def update
    @rule = Rule.find(params[:id])
    if @rule.update_attributes(params[:rule])
      flash[:success] = "Rule updated"
      redirect_to basecase_path(@rule.basecase_id)
    else
      @title = "Edit rule"
      render 'edit'
    end
  end
 
  def index
    @rules = Rule.all
  end

  def destroy
    Rule.find(params[:id]).destroy
    flash[:success] = "Rule deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to group_path(current_user.group_id)
    end
  end
  
  private

      def authorized_admin
          @rule = Rule.find(params[:id])
          @group = @rule.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @rule = Rule.find(params[:id])
          @group = @rule.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
