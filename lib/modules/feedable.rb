module Feedable
  def self.included(base)
    base.class_eval do
      before_save :generate_feeds

      include InstanceMethods
    end
  end

  module InstanceMethods
    def generate_feeds
      if self.new_record? || self.changed?
        FeedsManager.push_feeds(self)
      end
    end
  end
end