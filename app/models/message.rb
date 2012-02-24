class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from_id
  field :to_id
  field :content
  field :read, :type => Boolean, :default => false

  #relationships
  embedded_in :user

  #validations
  validates_presence_of :from_id
  validates_presence_of :to_id
  validates_presence_of :content
  validates_length_of :content, :maximum => 400

  def from
    @from ||= User.first(conditions: {_id: self.from_id})
    @from
  end

  def to
    @to ||= User.first(conditions: {_id: self.to_id})
    @to
  end
end