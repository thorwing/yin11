class Review < InfoItem
  field :faults, :type => Array, :default => []

  #relationships
  belongs_to :vendor
  tokenize_one :vendor

  attr_accessible :faults

  #override the settings in Informative
  validates_length_of :content, :maximum => 10000, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.content"),
                                                                           :max => 10000)
end
