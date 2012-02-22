class Solution
  include Mongoid::Document
  include Mongoid::Timestamps

  field :percentage, :type => Float, :default => 0
  field :creator_id
  field :content

  attr_accessible :content, :product_id, :recipe_id, :place_id

  #relationships
  belongs_to :desire, index: true
  belongs_to :product, index: true
  belongs_to :recipe, index: true
  belongs_to :place, index: true
  embeds_many :votes

  #validations
  validates_length_of :content, :maximum => 280

  def item
    @item ||= (place || product || recipe)
  end

  def name
    item ? item.name : ""
  end

  def voter_ids
    @voter_ids ||= self.votes.map(&:voter_id)
  end

  def voters
    @voters ||= User.any_in(_id: voter_ids)
  end

  def creator
    @creator ||= User.find(creator_id)
  end
end