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

    #def get_all_image_urls(thumb = false)
    #  images = []
    #  if self.respond_to?(:image)
    #    images << self.image
    #  elsif self.respond_to?(:images)
    #    images += self.images
    #  end
    #
    #  if images.empty?
    #    []
    #  else
    #    images.map{|i| thumb ? i.picture_url(:thumb) : i.picture_url(:waterfall) }
    #  end
    #end

  end

end