class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :user }

  def show
    #referesh
    @my_reviews = current_user.reviews
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
