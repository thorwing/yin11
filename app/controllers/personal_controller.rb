class PersonalController < ApplicationController
  before_filter(:only => [:me]) { |c| c.require_permission :normal_user }

  def me
    @all_feeds = FeedsManager.pull_feeds(current_user)
    @my_feeds = current_user.feeds
  end

end
