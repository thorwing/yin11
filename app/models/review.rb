class Review < Opinion
  field :severity, :type => Integer, :default => 0

  embeds_many :checkpoints

  accepts_nested_attributes_for :checkpoints,  :reject_if => lambda { |c| c[:name].blank? }, :allow_destroy => true

  attr_accessible :severity, :checkpoints_attributes


end
