module Votable
  def self.included(base)
    base.class_eval do
      before_save :sync_score

      field :score, type: Integer, default: 0
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

    def get_fans(user, limit)
      ids = []
      if user && is_fan?(user)
        ids = fan_ids.insert(0, fan_ids.delete(user.id.to_s))
      else
        ids = fan_ids
      end

      User.any_in(_id: ids).limit(3)
    end

  end

  module InstanceMethods
    def sync_score
      self.fan_ids ||= []
      self.hater_ids ||= []
      self.score = self.fan_ids.size - self.hater_ids.size
    end
  end
end