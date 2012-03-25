class ForwardcurvesController < ApplicationController

  before_filter :authorized_superadmin

  def new
      @forwardcurve = Forwardcurve.new
      @title = "New forwardcurve"
  end

  def show
      @forwardcurve = Forwardcurve.find(params[:id])
      @title = "forward curves"
  end

  def create
    @forwardcurve = Forwardcurve.new(params[:forwardcurve])
    if @forwardcurve.save 
      flash[:success] = "You have created a new forwardcurve"
      redirect_to forwardcurves_path
    else
      @title = "New forwardcurve"
      render 'new'
    end
  end

  def edit
      @forwardcurve = Forwardcurve.find(params[:id])  
      @title = "Edit forwardcurve" 
  end

  def update
    @forwardcurve = Forwardcurve.find(params[:id])
    if @forwardcurve.update_attributes(params[:forwardcurve])
      flash[:success] = "Forwardcurve updated"
      redirect_to forwardcurves_path
    else
      @title = "Edit forwardcurve"
      render 'edit'
    end
  end
 
  def index
    @title = "All forward curves"
    @forwardcurves = Forwardcurve.all
  end

  def destroy
    Forwardcurve.find(params[:id]).destroy
    flash[:success] = "Forwardcurve deleted"
    redirect_to Forwardcurves_path
  end

  private

      def authorized_superadmin
          redirect_to root_path unless current_user_superadmin(current_user)
      end


end
