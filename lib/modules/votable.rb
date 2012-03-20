module Votable
  def self.included(base)
    base.class_eval do
      before_save :sync_votes

      field :votes, type: Integer, default: 0
      field :fan_ids, type: Array, default: []
      field :hater_ids, type: Array, default: []
      field :history_fan_ids, type: Array, default: []

      include InstanceMethods
    end

    def fans
      @fans ||= User.any_in(_id: fan_ids)
      @fans
    end

    def haters
      @haters ||= User.any_in(_id: hater_ids)
      @haters
    end

    def is_fan?(user)
      self.fan_ids.include?(user.id)
    end

    def is_hater?(user)
      self.hater_ids.include?(user.id)
    end

  end

  module InstanceMethods
    def sync_votes
      self.fan_ids ||= []
      self.hater_ids ||= []
      self.votes = self.fan_ids.size - self.hater_ids.size
    end
  end
end