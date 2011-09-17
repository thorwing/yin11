class LocationsController < ApplicationController
  layout :resolve_layout

  def search
    coords = Geocoder.coordinates(params[:address])
    respond_to do |format|
      format.json { render :json => coords.to_json }
    end
  end

  def edit_current_city
    respond_to do |format|
      if params[:popup]
        format.html {render "edit_current_city", :layout => "dialog" }
      else
        format.html # new.html.erb
      end
    end
  end

  def update_current_city
    if params[:select_city].present?
      city = City.find(params[:select_city])
      if city
        self.current_city = city
      end
    end

    respond_to do |format|
      format.html {redirect_to root_url, :notice => t("notices.current_city_updated")}
    end
  end

  def show_nearby_items
    if params[:show_good].present?

    else
      @location = current_user.profile.watched_locations.find(params[:location_id])
      distance = current_user.profile.watched_distance
      #TODO
      @items = Review.near(@location.to_coordinates, distance).all
      #"picture" => "#{Rails.root.to_s}/public/images/bad_thumb.png"
      #id is for listing, not for map
      @markers_json = @items.to_gmaps4rails #vendors.inject([]){|memo, v| memo | v.reviews.all.map {|r| {"latitude" => v.latitude, "longitude" => v.longitude, "title" => r.title, "id" => r.id}} }
      @circles_json = [{"lat" => @location.latitude, "lng" => @location.longitude, "radius" => distance * 1000}].to_json
    end

    respond_to do |format|
      format.html
    end
  end

  def regions
    @regions = Province.only(:id, :name).where(:name => /#{params[:q]}?/) + City.only(:id, :name).where(:name => /#{params[:q]}?/)
    @regions.uniq! {|e| e.name}
    respond_to do |format|
      format.json { render :json => @regions.map { |e| {:id => e.id, :name => e.name } } }
    end
  end

  def cities
      province = Province.first(:conditions => {:id => params[:province_id]}) if params[:province_id]
      @cities = province.cities if province
      @cities ||= []

      respond_to do |format|
        format.json { render :json => @cities.map { |e| {:id => e.id, :name => e.name } } }
    end
  end

  private
  def resolve_layout
    case action_name
      when "show_nearby_items"
        'map'
      else
        'application'
    end
  end


end
