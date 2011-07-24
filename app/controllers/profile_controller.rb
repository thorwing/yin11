class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }
  before_filter { |c| c.user_self }

  def show
    @recent_items = current_user.info_items.of_type([Review.name, Recommendation.name]).desc(:updated_at).limit(PROFILE_RECENT_ITEMS).all
    @blocked_users = (current_user.blocked_user_ids || []).map{ |e| User.find(e) }
  end

  def edit

  end

  def update
    if current_user.profile.update_attributes(params[:profile])
      redirect_to profile_path(current_user), :notice => t("profile.profile_updated_notice")
    else
      redirect_to profile_path(current_user), :notice => "Error"
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

  def watch_foods
    current_user.profile.add_foods(params[:added_foods].split(","))
    current_user.save

    respond_to do |format|
      format.html {redirect_to :back}
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

  protected
  def user_self
    if params[:id] == current_user.id
      true
    else
      redirect_to :root, :alert => t("alert.no_such_profile_or_no_permission")
      false
    end
  end

end
