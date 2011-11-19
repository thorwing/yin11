module Feedable
  def self.included(base)
    base.class_eval do
      before_save :generate_feed

      include InstanceMethods
    end
  end

  module InstanceMethods
    def generate_feed
      FeedsManager.push_feeds(self)
    end
  end

end