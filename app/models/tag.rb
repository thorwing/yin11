class Tag
  include Mongoid::Document

  field :name
  key :name
  #item: "<type> <id>"
  field :items, :type => Array, :default => []


  #relationships
  embeds_many :feeds

  #validations
  validates_length_of :name, :maximum => 20

end