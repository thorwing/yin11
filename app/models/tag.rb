class Tag
  include Mongoid::Document

  field :name
  key :name

  attr_accessible :name

  #relationships
  has_and_belongs_to_many :groups
  embeds_many :feeds


end