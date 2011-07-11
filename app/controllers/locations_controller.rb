class LocationsController < ApplicationController
  def search
    coords = Geocoder.coordinates(params[:address])
    respond_to do |format|
      format.json { render :json => coords.to_json }
    end
  end
end