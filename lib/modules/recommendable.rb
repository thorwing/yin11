module Recommendable
  def self.included(base)
    base.class_eval do
      field :priority, :type => Integer, :default => 0

      #scopes
      scope :enabled, where(:priority.gte => 0)
      scope :recommended, where(:priority.gt => 0)
    end
  end
end
