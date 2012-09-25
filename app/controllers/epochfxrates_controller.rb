class EpochfxratesController < ApplicationController

  before_filter :authorized_superadmin

  def new
      @epochfxrate = Epochfxrate.new
      @title = "New epoch fxrate"
  end

  def show
      @epochfxrate = Epochfxrate.find(params[:id])
      @title = "Epoch fxrates"
  end

  def create
    @epochfxrate = Epochfxrate.new(params[:epochfxrate])
    if @epochfxrate.save 
      flash[:success] = "You have created a new epoch fxrate"
      redirect_to epochfxrates_path
    else
      @title = "New epoch fxrate"
      render 'new'
    end
  end

  def edit
      @epochfxrate = Epochfxrate.find(params[:id])  
      @title = "Edit epoch fxrate" 
  end

  def update
    @epochfxrate = Epochfxrate.find(params[:id])
    if @epochfxrate.update_attributes(params[:epochfxrate])
      flash[:success] = "Epoch fxrate updated"
      redirect_to epochfxrates_path
    else
      @title = "Edit epoch fxrate"
      render 'edit'
    end
  end
 
  def index
    @title = "All epoch fxrates"
    @epochfxrates = Epochfxrate.all
  end

  def destroy
    Epochfxrate.find(params[:id]).destroy
    flash[:success] = "Epoch fxrate deleted"
    redirect_to Epochfxrates_path
  end

  private

      def authorized_superadmin
          redirect_to root_path unless current_user_superadmin(current_user)
      end


end
