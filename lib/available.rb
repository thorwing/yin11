module Available
  def self.included(base)
    base.class_eval do
      scope :enabled, where(disabled: false)
      scope :disabled, where(disabled: true)
      field :disabled, :type => Boolean, :default => false
    end
  end
end