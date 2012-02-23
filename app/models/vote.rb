class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content
  field :voter_id

  attr_accessible :content

  #relationships
  embedded_in :solution

  validates_length_of :content, :maximum => 280

  def voter
    @voter ||= User.find(voter_id)
  end

end