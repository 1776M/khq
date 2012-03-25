class SwapcurvesController < ApplicationController

  before_filter :authorized_superadmin

  def new
      @swapcurve = Swapcurve.new
      @title = "New swapcurve"
  end

  def show
      @swapcurve = Swapcurve.find(params[:id])
      @title = "swap curves"
  end

  def create
    @swapcurve = Swapcurve.new(params[:swapcurve])
    if @swapcurve.save 
      flash[:success] = "You have created a new swapcurve"
      redirect_to swapcurves_path
    else
      @title = "New swapcurve"
      render 'new'
    end
  end

  def edit
      @swapcurve = Swapcurve.find(params[:id])  
      @title = "Edit swapcurve" 
  end

  def update
    @swapcurve = Swapcurve.find(params[:id])
    if @swapcurve.update_attributes(params[:swapcurve])
      flash[:success] = "Swapcurve updated"
      redirect_to swapcurves_path
    else
      @title = "Edit swapcurve"
      render 'edit'
    end
  end
 
  def index
    @title = "All swap curves"
    @swapcurves = Swapcurve.all
  end

  def destroy
    Swapcurve.find(params[:id]).destroy
    flash[:success] = "Swapcurve deleted"
    redirect_to swapcurves_path
  end

  private

      def authorized_superadmin
          redirect_to root_path unless current_user_superadmin(current_user)
      end


end
