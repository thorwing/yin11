module Available
  def self.included(base)
    base.class_eval do
      scope :enabled, where(:enabled => true)
      scope :disabled, where(:enabled => false)
      field :enabled, :type => Boolean, :default => true
      field :recommended, :type => Boolean, :default => false

      attr_accessible :enabled, :recommended

    end
  end
end
