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
    post = Annual.save(params[:upload])
    @filename = params[:upload]
    flash[:success] = "File has been uploaded successfully"
  end

end
