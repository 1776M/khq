class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def contact 
  end

  def uploadfile
    @group= current_user.group
    @basecase = Basecase.find(:last, :conditions => [" group_id = ?", @group.id])
    post = Annual.save(params[:upload])
    @filename = params[:upload]
    flash[:success] = "File has been uploaded successfully"
  end

  def uploadfiletwo
    @group= current_user.group
    @basecase = Basecase.find(:last, :conditions => [" group_id = ?", @group.id])
    @scenario = Scenario.find(params[:scenario_id])    
    post = Annual.save(params[:upload])
    @filename = params[:upload]
    flash[:success] = "File has been uploaded successfully"
  end

  def board
    @basecase = current_user.group.basecases.find(:last)
    @dashboard = Dashboard.new if signed_in?
    @dashboards = @basecase.dashboards
  end

end
