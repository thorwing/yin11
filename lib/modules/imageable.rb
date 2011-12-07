module Imageable
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def get_image_url(thumb = false, index = 0)
      image = nil
      if self.respond_to?(:image) && index == 0
        image = self.image
      elsif self.respond_to?(:images)
        image = self.images.first if index < self.images.size
      end

      if image
        thumb ? image.picture_url(:thumb) : image.picture_url
      else
        "not_found.png"
      end
    end
  end

end