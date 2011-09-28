class Tag
  include Mongoid::Document

  field :name
  key :name

  attr_accessible :name

  #relationships
  belongs_to :groups


end