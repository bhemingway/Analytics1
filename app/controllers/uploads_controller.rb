class UploadsController < ApplicationController
  def index
     #render :file => 'app\views\upload\uploadfile.rhtml'
  end

  def create
    post = DataFile.save(params[:upload])
    #render :text => t('upload_page.upload_ok_text')
    render 'index'
  end
end
