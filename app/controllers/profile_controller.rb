class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :user }

  def show
    #referesh
    @my_reviews = current_user.reviews
    @my_badge_ids = current_user.badge_ids
    @my_badges = current_user.badges
  end

  def edit
    @profile = current_user.profile
  end

  def update
    if current_user.profile.update_attributes(params[:profile])
      redirect_to profile_show_path, :notice => t("profile.profile_updated_notice")
    else
      redirect_to profile_show_path, :notice => "Error"
    end
  end

  def edit_current_city
    respond_to do |format|
      if params[:popup]
        format.html {render "edit_current_city", :layout => "popup" }
      else
        format.html # new.html.erb
      end
    end
  end

  def update_current_city
    self.current_city = City.find(params[:new_city]) if params[:new_city].present?
    @current_city_name = self.current_city.name

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

end
