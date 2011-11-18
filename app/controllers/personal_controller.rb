class PersonalController < ApplicationController
  before_filter(:only => [:me]) { |c| c.require_permission :normal_user }
  layout "two_columns"

  def me
    @feeds = current_user.feeds
  end

end
