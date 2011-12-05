class ImagesController < ApplicationController
  #before_filter :find_or_build_image

  def create
    @image = Image.new
    if params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile)
      @image.picture = AppSpecificStringIO.new(params[:qqfile].original_filename, params[:qqfile].read)
    else
      @image.picture = AppSpecificStringIO.new(params[:qqfile], request.body.read)
    end
    @limit = IMAGES_LIMIT

    if @image.save!
      #tempfile = params[:image][:picture].tempfile.path
      #if File::exists?(tempfile)
      #  File::delete(tempfile)

      data = { :success => true, :picture_url => @image.picture_url, :image_id => @image.id}
      respond_to do |format|
        format.html { render :json => data }
        format.json { render :json => data }
      end
    end
  end

  def upload
#    upload_file = params[:images].last
#    @image = Image.new
#    @image.picture = AppSpecificStringIO.new(upload_file.original_filename, upload_file.read)
#    @limit = IMAGES_LIMIT
#    if @image.save!
#      respond_to do |format|
#        format.js
#      end
#    end
  end

  #private
  #def find_or_build_image
  #  @image = Image.new(params[:image])
  #  @limit = IMAGES_LIMIT
  #end

end