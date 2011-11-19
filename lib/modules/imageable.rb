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
      if self.images && self.images.size > 0
        self.images.first.picture_url
      else
        "default_article.jpg"
      end
    end
  end

end