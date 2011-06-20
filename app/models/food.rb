class Food
  include Mongoid::Document
  field :name
  key :name
  field :aliases, :type => Array, :default => []

  def aliases_string
    aliases.join(";")
  end

  def aliases_string=(aliases_str)
    self.aliases = aliases_str.split(";")
  end

  #Relationships
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :reviews
  has_and_belongs_to_many :categories

  #validators
  validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name"))
  validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))

  attr_accessible :name, :aliases_string, :category_ids

end
