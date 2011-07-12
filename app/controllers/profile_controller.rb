class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }
  layout :resolve_layout

  def show
    #referesh

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
    @location = current_user.profile.watched_locations.new(:city => params[:city], :detail => params[:detail])
    @location.save

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

  def delete_watched_location

  end

  private
  def resolve_layout
    case action_name
      when 'edit'
        "map"
      else
        "application"
    end
  end

end
