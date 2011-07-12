class LocationsController < ApplicationController
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
end