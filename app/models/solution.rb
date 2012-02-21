class Solution
  include Mongoid::Document
  include Mongoid::Timestamps

  field :percentage, :type => Float, :default => 0
  field :creator_id

  #relationships
  belongs_to :desire, index: true
  belongs_to :product, index: true
  belongs_to :recipe, index: true
  belongs_to :place, index: true
  has_and_belongs_to_many :voters, :class_name => "User", index: true
  embeds_many :votes

  def item
    @item ||= (place || product || recipe)
  end

  def name
    item ? item.name : ""
  end

  def voter_ids
    @voter_ids ||= self.votes.map(&:voter_id)
  end
end