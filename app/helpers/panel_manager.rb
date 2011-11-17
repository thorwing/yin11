class PanelManager
  def initialize(user)
    @current_user = user
    #@current_city = city
    @days = @current_user ? @current_user.profile.concern_days : (PROFILE_MIN_CONCERN_DAYS + PROFILE_MAX_CONCERN_DAYS) / 2
    @distance = @current_user ? @current_user.profile.watched_distance : (PROFILE_MIN_WATCHED_DISTANCE + PROFILE_MAX_WATCHED_DISTANCE) / 2
  end

  def get_reviews_around(location)
    #Review.near(:latlng =>  [location.latitude,location.longitude, @distance]).all
    reviews = Review.enabled.in_days_of(@days).near(location.location).limit(MAX_NEARBY_ITEMS)
    #result of Geocoder is in miles
    reviews.reject{|r| (r.latitude.blank? || r.longitude.blank? || location.latitude.blank? || location.longitude.blank?) || Geocoder::Calculations.distance_between([r.latitude, r.longitude], [location.latitude, location.longitude]) > (@distance.to_f * MILES_OF_KILOMETERS)}
    #Review.where(:location => {"$near" => [location.latitude, location.longitude], "$maxDistance" => 100000.0})
    #Review.where(:location.near => [location.latitude, location.longitude]).all
    #Review.where(:location.within => { "$center" => [ [location.latitude, location.longitude], 10000 ] }).all
  end
  #
  #def get_items_tagged_with(tag)
  #  InfoItem.enabled.in_days_of(@days).tagged_with([tag]).all
  #end

  def get_items_from(group)
    Review.enabled.in_days_of(@days).any_in(:author_id => group.member_ids).all
  end

end