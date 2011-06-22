class Review < InfoItem
  embeds_many :checkpoints

  accepts_nested_attributes_for :checkpoints,  :reject_if => lambda { |c| c[:name].blank? }, :allow_destroy => true

  attr_accessible :checkpoints_attributes

  #override the settings in Informative
  validates_length_of :content, :maximum => 10000, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.content"),
                                                                           :max => 10000)
end
