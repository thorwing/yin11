module HomeHelper
  def get_bad_items_near_by(location)
    vendors = Vendor.near(location.to_coordinates, current_user.profile.watched_distance)
    reviews = vendors.inject([]){|memo, v| memo | v.reviews.all }
    reviews
  end
end
