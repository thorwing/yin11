class PanelManager
  def initialize(user)
    @current_user = user
    #@current_city = city
    @days = @current_user ? @current_user.profile.concern_days : (PROFILE_MIN_CONCERN_DAYS + PROFILE_MAX_CONCERN_DAYS) / 2
    @distance = @current_user ? @current_user.profile.watched_distance : (PROFILE_MIN_WATCHED_DISTANCE + PROFILE_MAX_WATCHED_DISTANCE) / 2
  end

  def get_reviews_around(location)
    Review.near(location.to_coordinates, @distance).enabled.in_days_of(@days).all
  end

  def get_items_tagged_with(tag)
    InfoItem.enabled.in_days_of(@days).tagged_with([tag]).all
  end

  def get_items_from(group)
    Review.enabled.in_days_of(@days).any_in(:author_id => group.member_ids).all
  end

end