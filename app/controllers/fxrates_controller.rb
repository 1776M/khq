class FxratesController < ApplicationController

  before_filter :authorized_superadmin

  def new
      @fxrate = Fxrate.new
  end

  def show
      @fxrate = Fxrate.find(params[:id])
  end

  def create
    @fxrate = Fxrate.new(params[:fxrate])
    if @fxrate.save 
      flash[:success] = "You have created a new fxrate"
      redirect_to fxrates_path
    else
      @title = "New Fxrate"
      render 'new'
    end
  end

  def edit
      @fxrate = Fxrate.find(params[:id])   
  end

  def update
    @fxrate = Fxrate.find(params[:id])
    if @fxrate.update_attributes(params[:fxrate])
      flash[:success] = "Fxrate updated"
      redirect_to fxrates_path
    else
      @title = "Edit Fxrate"
      render 'edit'
    end
  end
 
  def index
    @fxrates = Fxrate.all
  end

  def destroy
    Fxrate.find(params[:id]).destroy
    flash[:success] = "Fxrate deleted"
    redirect_to fxrates_path
  end

  private

      def authorized_superadmin
          redirect_to root_path unless current_user_superadmin(current_user)
      end

end
