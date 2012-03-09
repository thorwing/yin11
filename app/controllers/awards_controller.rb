class AwardsController < ApplicationController
  before_filter :preload
  before_filter(:only => [:claim]) { |c| c.require_permission :normal_user }

  def index
    @awards = Award.all
  end

  def show

  end

  def claim

  end

  private

  def preload
    @award = Award.find(params[:id]) if params[:id].present?
  end

end
