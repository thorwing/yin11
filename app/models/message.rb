class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from
  field :body

  #relationships
  embedded_in :user

  #validations
  validates_presence_of :from
  validates_presence_of :body
  validates_length_of :body, :maximum => 300
end