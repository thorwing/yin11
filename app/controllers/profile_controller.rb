class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def show
    @recent_items = current_user.info_items.of_type([Review.name, Recommendation.name]).desc(:updated_at).limit(GlobalConstants::PROFILE_RECENT_ITEMS).all
  end

  def edit

  end

  def update
    if current_user.profile.update_attributes(params[:profile])
      redirect_to profile_show_path, :notice => t("profile.profile_updated_notice")
    else
      redirect_to profile_show_path, :notice => "Error"
    end
  end

  def new_watched_location
    respond_to do |format|
      if params[:popup]
        format.html {render "new_watched_location", :layout => "dialog" }
      else
        format.html
      end
    end
  end

  def create_watched_location
    @location = current_user.profile.watched_locations.new(:city => params[:city], :street => params[:street])
    @location.save

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

  def delete_watched_location
    @location = current_user.profile.watched_locations.find(params[:location_id])
    @location.delete
    #current_user.profile.save

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

end
