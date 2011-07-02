class Source
  include Mongoid::Document

  field :name, :type => String
  field :site, :type => String
  field :url, :type => String

  validates_presence_of :name
  validates_length_of :name, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("articles.source_name"), :max => 20)
  validates_length_of :site, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("articles.source_site"), :max => 20)

  attr_accessible :name, :site, :url

  #Relationships
  embedded_in :article
  embedded_in :review

end