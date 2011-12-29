class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def show

  end

  def edit
    current_user.profile.current_step = params[:step]
  end

  def update
    current_user.profile.update_attributes(params[:profile]) if params[:profile].present?
    current_user.update_attributes(params[:user]) if params[:user].present?

    render :action => :edit
  end

end
