class ImagesController < ApplicationController
  #before_filter :find_or_build_image

  def create
     @image = Image.new(params[:image])
    @limit = IMAGES_LIMIT

    if @image.save
      tempfile = params[:image][:picture].tempfile.path
      if File::exists?(tempfile)
        File::delete(tempfile)
      end

      respond_to do |format|
        format.html { redirect_to :back, :notice => 'Image successfully created' }
        format.js
      end
    end
  end

  def upload
    upload_file = params[:images].last
    @image = Image.new
    @image.picture = AppSpecificStringIO.new(upload_file.original_filename, upload_file.read)
    @limit = IMAGES_LIMIT
    if @image.save!
      respond_to do |format|
        format.js
      end
    end
  end

  #private
  #def find_or_build_image
  #  @image = Image.new(params[:image])
  #  @limit = IMAGES_LIMIT
  #end

end