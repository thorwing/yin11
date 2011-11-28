module Imageable
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def get_image()
      if self.image && self.image.picture_url
        self.image.picture_url
      else
        "default_article.jpg"
      end
    end

    def get_first_image()
      if self.respond_to?(:image)
        if self.image && self.image.picture_url
          return self.image.picture_url
        end
      elsif self.respond_to?(:images)
        if self.images && self.images.size > 0
          return self.images.first.picture_url
        end
      end

      "default_article.jpg"
    end
  end

end