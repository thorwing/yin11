class ImagesController < ApplicationController
  before_filter :find_or_build_image

  def create
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

private
  def find_or_build_image
    @image = Image.new(params[:image])
  end

end