module PlacesHelper
  def self.process_place(item, city, place_name, place_street)
    if place_name.present? && place_street.present?
      place = Place.find_or_initialize_by(city: city, name: place_name, street: place_street)
      if place.new_record?
        place.city = city
        place.name = place_name
        place.street = place_street
        #only set the place if it's valid
        item.place = place if place.save
      else
        item.place = place
      end
    end
  end

end