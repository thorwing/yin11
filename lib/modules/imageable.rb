module Imageable
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def get_image_url(thumb = false, index = 0, origin = true)
      image = nil
      if self.respond_to?(:image) && index == 0
        image = self.image
      elsif self.respond_to?(:images)
        image = self.images.first if index < self.images.size
      end

      if image
        thumb ? image.picture_url(:thumb) : image.picture_url
      else
        #origin url is used for image_tag, the other one is used for waterfall displaying
        origin ? "not_found.png" : "/assets/not_found.png"
      end
    end

    def get_all_image_urls(thumb = false)
      images = []
      if self.respond_to?(:image)
        images << self.image
      elsif self.respond_to?(:images)
        images += self.images
      end

      if images.empty?
        ["/assets/not_found.png"]
      else
        images.map{|i| thumb ? i.picture_url(:thumb) : i.picture_url }
      end
    end

    def has_image?
      if self.respond_to?(:image)
        return true if self.image
      elsif self.respond_to?(:images)
        return true unless self.images.empty?
      end

      false
    end
  end

end