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


end
