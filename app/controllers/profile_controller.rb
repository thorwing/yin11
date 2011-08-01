class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def show
    @recent_items = current_user.info_items.of_types([Review.name]).desc(:updated_at).limit(PROFILE_RECENT_ITEMS).all
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
    @location.save!
    current_user.profile.save!

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

  def watch_tags
    current_user.profile.watch_tags!(params[:tags])

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

  def delete_watched_tag
    @index = current_user.profile.watched_tags.index(params[:tag])
    if @index >= 0
      current_user.profile.watched_tags.slice!(@index)
      current_user.profile.save!
    end

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

  def toggle
    @field = params[:field]
    @new_value = !current_user.profile[@field]
    current_user.profile[@field] = @new_value
    current_user.profile.save!

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

end
