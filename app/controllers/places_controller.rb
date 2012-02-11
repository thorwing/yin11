class PlacesController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :normal_user }

  def index
    @places = Place.all

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
end
