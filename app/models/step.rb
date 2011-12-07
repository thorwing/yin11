class Step
  include Mongoid::Document
  field :num, :type => Integer
  field :content, :type => String
  field :img_id
  has_one :images

  embedded_in :recipe

  validates_presence_of :content
  validates_length_of :content, :maximum => 100
end
