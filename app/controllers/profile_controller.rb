class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def show
    @recent_items = current_user.info_items.of_types([Review.name]).desc(:updated_at).limit(PROFILE_RECENT_ITEMS).all
  end

  def edit
    current_user.profile.current_step = session[:profile_step]
  end

  def update
    current_user.profile.current_step = session[:profile_step]

    current_user.profile.update_attributes(params[:profile]) if params[:profile].present?
    current_user.update_attributes(params[:user]) if params[:user].present?

    editing = true
    if params[:previous_button]
      current_user.profile.previous_step
    elsif current_user.profile.last_step?
      editing = false
    else
      current_user.profile.next_step
    end

    session[:profile_step] = current_user.profile.current_step

    if editing
      #@current_user.profile.cached_params= old
	    render :action => :edit
    else
	    session[:profile_step] = nil
	    redirect_to root_path, :notice => t("profile.profile_updated_notice")
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
