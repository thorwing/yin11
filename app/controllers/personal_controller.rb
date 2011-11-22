class PersonalController < ApplicationController
  before_filter(:only => [:me]) { |c| c.require_permission :normal_user }

  def me
  end

  def my_feeds
      @feeds = current_user.feeds
      respond_to do |format|
        format.html  {render "get_feeds", :layout => "dialog"}
      end
  end

  def all_feeds
      @feeds = FeedsManager.pull_feeds(current_user)
      respond_to do |format|
        format.html  {render "get_feeds", :layout => "dialog"}
      end
  end

end
