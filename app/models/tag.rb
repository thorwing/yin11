class Tag
  include Mongoid::Document

  field :title
  key :title

  #relationships
  has_and_belongs_to_many :tips

  attr_accessible :title

  validates_presence_of :title, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.title") )
  validates_uniqueness_of :title, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))
  validates_length_of :title, :maximum => 10, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.title"),
                                                                         :max => 10)

end
