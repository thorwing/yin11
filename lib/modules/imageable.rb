module Imageable
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def get_image(index = 0)
      image = nil
      if self.respond_to?(:image) && index == 0
        image = self.image
      elsif self.respond_to?(:images)
        image = self.images.first if index < self.images.size
      end

      image
    end

    def get_image_url(version = nil, index = 0)
      image = get_image(index)
      image ? image.picture_url(version) : ''
    end

    def get_image_height(version = nil, index = 0)
      image = get_image(index)
      if image
        if version == :waterfall && image.waterfall_height.present?
          #new solution: use cached filed
          image.waterfall_height.to_i
        else
          #old solution: calculate and cache it, prepare to retire
          img_attributes = nil
          sub_key = version ? "#{version.to_s}_height" : "origin_height"
          img_attributes = Rails.cache.read(image.picture_url(version))
          unless img_attributes.present? && img_attributes[sub_key]
            picture = version ? image.picture.versions[version] : image.picture
            img = Magick::Image::from_blob(picture.read).first
            img_attributes ||= {}
            img_attributes[sub_key] = img.rows
            Rails.cache.write(image.picture_url(version), img_attributes, :time_to_idle => 60.seconds, :timeToLive => 600.seconds)
          end

          image.waterfall_height = img_attributes[sub_key]
          image.save

          image.waterfall_height
        end
      else
        0
      end
    end
  end

end