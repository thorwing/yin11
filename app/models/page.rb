class Page
  include Mongoid::Document
  field :title
  field :content

  #validations
  validates_presence_of :title
  validates_length_of :title, :maximum => 50
  validates_presence_of :content
end
