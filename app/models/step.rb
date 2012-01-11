class Step
  include Mongoid::Document
  include Imageable

  #fields
  field :content, :type => String
  field :img_id

  attr_accessible  :content, :img_id , :img_url

  #relationships
  has_one :image
  embedded_in :recipe

  #validations
  validates_length_of :content, :maximum => 200

end
