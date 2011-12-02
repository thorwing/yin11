class Step
  include Mongoid::Document
  field :num, :type => Integer
  field :content, :type => String
  has_one :images
end
