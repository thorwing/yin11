module Votable
  def self.included(base)
    base.class_eval do
      field :votes, :type => Integer, :default => 0
      field :fan_ids, :type => Array, :default => []
    end

    def fans
      User.any_in(_id: fan_ids)
    end

  end
end