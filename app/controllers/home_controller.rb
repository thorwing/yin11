class HomeController < ApplicationController
  def index
    @user = current_user

    @recent_reviews = Review.desc(:updated_at)
  end
end
