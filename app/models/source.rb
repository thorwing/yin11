class Source
  include Mongoid::Document

  field :name
  field :site
  field :url

  validates_length_of :name, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.source"), :max => 20)
  validates_length_of :site, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.source"), :max => 20)

  attr_accessible :name, :site, :url

  #Relationships
  embedded_in :article
  embedded_in :review

end