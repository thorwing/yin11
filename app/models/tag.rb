class Tag
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry

  field :name
  key :name
  field :is_category, :type => Boolean
  field :product_ids, :type => Array, :default => []

  attr_accessible :name, :is_category

  #scopes
  scope :categories, where(:is_category => true)

  #relationships
  has_and_belongs_to_many :groups
  embeds_many :feeds

  #validations
  validates_length_of :name, :maximum => 20

end