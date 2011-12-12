class ImagesController < ApplicationController
  before_filter(:only => [:create, :destroy]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:new, :edit, :update]) { |c| c.require_permission :editor }

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(params[:image])
    if params[:qqfile].present?
      #upload via plugin
      if params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile)
        uploaded_file = params[:qqfile]
        @image.picture = AppSpecificStringIO.new(uploaded_file.original_filename, uploaded_file.read)
        File::delete(uploaded_file.tempfile.path) if File::exists?(uploaded_file.tempfile.path)
      elsif  params[:qqfile].is_a?(String)
        @image.picture = AppSpecificStringIO.new(params[:qqfile], request.body.read)
      end
    end
      #upload via normal file filed
      #@image = Image.new(params[:image])

    @limit = IMAGES_LIMIT

    if @image.save!
      data = { :success => true, :picture_url => @image.picture_url, :image_id => @image.id}
      respond_to do |format|
        format.html { redirect_to @image }
        format.json { render :json => data }
      end
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to(@image) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    render :text => ""
  end

end