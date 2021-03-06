module Followable
  def self.included(base)
    base.class_eval do
      field :followers, :type => Array, :default => []

      attr_accessible :followers

      include InstanceMethods
    end
  end

  module InstanceMethods
    def add_follower!(user)
      self.followers ||= []
      unless self.followers.include?(user.id.to_s)
        self.followers << user.id.to_s
        self.save
      end
    end

    def remove_follower!(user)
      return unless followers.present?
      self.followers.delete(user.id.to_s)
      self.save
    end

  end

end