class ImagesController < ApplicationController
  before_filter :find_or_build_image

  def create
    if @image.save
      respond_to do |format|
        format.html { redirect_to :back, :notice => 'Image successfully created' }
        format.js
      end
    end
  end

private
  def find_or_build_image
    #@image = params[:id] ? @review.images.find(params[:id]) : @review.images.build(params[:image])
    @image = Image.new(params[:image])
    @image.info_item_id = params[:item_id]
  end

end