class AlbumsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :normal_user }

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all.page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(params[:album])
    @album.author_id = current_user.id

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: t("notices.album_created") }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "new" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.json
  def update
    @album = Album.find(params[:id])
    #make sure only the editor can set priority
    if current_user_has_permission?(:editor) && params[:album][:priority].present?
      @album.priority = params[:album][:priority].to_i
    end

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to @album, notice: t("notices.album_updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :ok }
    end
  end

  def collect
    @album = Album.find(params[:id])
    @item = find_item_by_type_and_id(params[:item_type], params[:item_id])
    if @item.is_a? Review
      @album.review_ids ||= []
      @album.review_ids << @item.id.to_s
      @album.save

      @item.album_ids ||= []
      @item.album_ids << @album.id.to_s
      @item.save
    end

    respond_to do |format|
      format.js
    end
  end

  def pick_cover
    @album = Album.find(params[:id])
    @item = find_item_by_type_and_id(params[:item_type], params[:item_id])
    if @item.is_a? Review
      imageable = @item.get_imageable_item
      if imageable
        image = imageable.get_image
        if image
          @new_cover_url = image.picture_url(:waterfall)
          @album.cover_id = image.id
          @album.save
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end

end