class Step
  include Mongoid::Document
  field :num, :type => Integer
  field :content, :type => String
  field :img_id
  field :img_url
  has_one :images
  attr_accessible  :content, :img_id , :img_url

  embedded_in :recipe

  validates_presence_of :content
  validates_length_of :content, :maximum => 100
end
