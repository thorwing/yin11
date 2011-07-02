class Category
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry

  field :name, :type => String
  #key :name
  field :ancestry
  index :ancestry

  #relationships
  has_and_belongs_to_many :foods

  validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name") )
  validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name") )
end