class Solution
  include Mongoid::Document
  include Mongoid::Timestamps

  field :percentage, :type => Float, :default => 0
  field :content

  attr_accessible :content, :product_id, :recipe_id, :place_id

  #relationships
  belongs_to :desire, index: true
  belongs_to :product, index: true
  belongs_to :recipe, index: true
  belongs_to :place, index: true
  belongs_to :author, :class_name => "User", index: true
  embeds_many :votes

  #validations
  validates_length_of :content, :maximum => 1000

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

  #def can_vote?(user)
  #  user.present? && (!self.desire.vote_ids.include?(user.id)) && (self.author != user)
  #end
end