class WikiCategory
  include Mongoid::Document
  field :name

  #Validators
  validates_uniqueness_of :name

  #Relationships
  has_many :pages, :class_name => "WikiPage"
end
