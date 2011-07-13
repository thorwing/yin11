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
        # is it true?
        if params[:reload_vendors].match(/(true|t|yes|y|1)$/i) != nil
          @vendors = Vendor.enabled.of_city(self.current_city.name).all
        end
      end
    end

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

  def show_nearby_items
    if params[:show_good].present?

    else
      @location = current_user.profile.watched_locations.find(params[:location_id])
      distance = current_user.profile.watched_distance
      vendors = Vendor.near(@location.to_coordinates, distance)
      #"picture" => "#{Rails.root.to_s}/public/images/bad_thumb.png"
      #id is for listing, not for map
      @markers_data = vendors.inject([]){|memo, v| memo | v.reviews.all.map {|r| {"latitude" => v.latitude, "longitude" => v.longitude, "title" => r.title, "id" => r.id}} }
      @circles_json = [{"latitude" => @location.latitude, "longitude" => @location.longitude, "radius" => distance * 1000}].to_json
    end

    respond_to do |format|
      format.html
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
