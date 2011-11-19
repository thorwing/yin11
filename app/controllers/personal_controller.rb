class PersonalController < ApplicationController
  before_filter(:only => [:me]) { |c| c.require_permission :normal_user }

  def me
    @feeds = current_user.feeds
  end

end
