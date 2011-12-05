class Step
  include Mongoid::Document
  belongs_to :recipe
  field :num, :type => Integer
  field :content, :type => String
  has_one :images
end
