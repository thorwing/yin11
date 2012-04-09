class PlacesController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :normal_user }

  def index
    @places = Place.all.page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @place = Place.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to @place, notice: t("notices.place_updated") }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url }
    end
  end

  def query
    query_str = params[:q]
    if query_str.present?
      # not case sensitive
      @places = Place.where(name: /#{query_str}/i).to_a #CacheManager.all_tags_with_weight.select {|t| t[0] =~ /#{query}?/}
    else
      @places = Place.all.to_a
    end

    #truncate the tag name
    new_place_name = query_str[0..(MAX_TAG_CHARS - 1)]
    is_new_place = @places.select{|p| p.name.include?(new_place_name)}.empty?
    #new_tag = Tag.create(:name => new_tag_name) if is_new_tag

    #TODO to_s
    @places =  @places.map { |p| {id: p.name, name: p.name, street: p.street } }

    #insert new tag
    @places.insert(0, {:id => new_place_name, :name => "#{new_place_name} (#{t("places.new_place")})" }) if is_new_place

    respond_to do |format|
      format.json { render :json => @places }
    end
  end

  def browse
    if params[:name].present?
      # not case sensitive
      @places = Place.where(name: /#{params[:name]}/i)
    end
    @places ||= []

    respond_to do |format|
      format.js
    end
  end

end
