class Food
  include Mongoid::Document
  field :name
  key :name

  #Relationships
  has_and_belongs_to_many :articles
  has_many :reviews
  has_and_belongs_to_many :categories

  #validators
  validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name"))
  validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))

end
