class AnnualsController < ApplicationController

  before_filter :authorized_admin, :only => [:show] 
  before_filter :authorized_group_member, :only => [:show]

  def show
      @annual = Annual.find(params[:id])
      @currency = Currency.new if signed_in?
      @currencies = @annual.currencies
  end

  def create
    @basecase = Basecase.find(params[:basecase_id])    
    @annual = @basecase.annuals.build(params[:annual])   
    if @annual.save
      flash[:success] = "You have created new data"
      redirect_to basecase_path(@annual.basecase_id)
    else
      render 'new'
    end

    params = Hash.new  
    params[:currency] = {
     
             currency_name: "EUR",
             year_0: 1,
             year_1: 1,
             year_2: 1,
             year_3: 1,
             year_4: 1,
             year_5: 1,            
             annual_id: @annual.id
             }

    @currency = @annual.currencies.build(params[:currency])
    if @currency.save
      # this is just a dummy variable to do something in the loop
      a = 1
    end   

  end

  def edit 
      @annual = Annual.find(params[:id]) 
  end

  def update
    @annual = Annual.find(params[:id])
    if @annual.update_attributes(params[:annual])
      flash[:success] = "Data updated"
      redirect_to @annual
    else
      @title = "Edit data"
      render 'edit'
    end
  end
 
  def index
    @title = "All data"
    @annuals = Annual.all
  end

  def destroy
    @basecase = Annual.find(params[:id]).basecase
    Annual.find(params[:id]).destroy
    flash[:success] = "Data deleted"
    if current_user.name == 'mandeep3'     
        redirect_to basecase_path
    else
        redirect_to basecase_path(@basecase.id)
    end
  end

  def bulk_create
    @basecase = current_user.group.basecases(:last)
    @thegrid = params[:thegrid]
    @thegrid.each do |thegrid|
       flash[:success] = "You have created new data"
 
       # @annual = @basecase.annuals.build(params[thegrid])
    end 
  end

  
  private

      def authorized_admin
          @annual = Annual.find(params[:id])
          @group = @annual.basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @annual = Annual.find(params[:id])
          @group = @annual.basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end

end
