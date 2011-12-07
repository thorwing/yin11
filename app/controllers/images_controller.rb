class ImagesController < ApplicationController
  def create
    @image = Image.new
    if params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile)
      uploaded_file = params[:qqfile]
      @image.picture = AppSpecificStringIO.new(uploaded_file.original_filename, uploaded_file.read)
      File::delete(uploaded_file.tempfile.path) if File::exists?(uploaded_file.tempfile.path)
    else
      @image.picture = AppSpecificStringIO.new(params[:qqfile], request.body.read)
    end
    @limit = IMAGES_LIMIT

    if @image.save!
      data = { :success => true, :picture_url => @image.picture_url, :image_id => @image.id}
      respond_to do |format|
        format.html { render :json => data }
        format.json { render :json => data }
      end
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    render :text => ""
  end

end