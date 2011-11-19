class PersonalController < ApplicationController
  before_filter(:only => [:me]) { |c| c.require_permission :normal_user }

  def me
    @feeds = FeedsManager.pull_feeds(current_user)
  end

end
