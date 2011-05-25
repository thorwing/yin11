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

end
