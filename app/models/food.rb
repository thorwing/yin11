class Food
  include Mongoid::Document
  include Taggable

  field :aliases, :type => Array, :default => []

  def aliases_string
    aliases.join(";")
  end

  def aliases_string=(aliases_str)
    self.aliases = aliases_str.split(";")
  end

  #Relationships
  has_and_belongs_to_many :categories

  #validators
  attr_accessible :aliases_string, :category_ids

end
