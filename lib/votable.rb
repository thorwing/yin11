module Votable
  def self.included(base)
    base.class_eval do
      field :votes, :type => Integer, :default => 0
      field :fan_ids, :type => Array, :default => []
      field :hater_ids, :type => Array, :default => []
    end
  end
end