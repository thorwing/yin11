class LocationsController < ApplicationController
  def search
    results = Geocoder.search params[:address]
    coords = results.first.coordinates
    respond_to do |format|
      format.json { render :json => coords.to_json }
    end
  end
end