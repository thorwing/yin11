class Solution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Votable

  field :percentage, :type => Float, :default => 0
  field :content

  attr_accessible :content, :product_id, :recipe_id, :place_id, :tuan_id

  #relationships
  belongs_to :desire, index: true
  belongs_to :product, index: true
  belongs_to :recipe, index: true
  belongs_to :place, index: true
  belongs_to :tuan, index: true
  belongs_to :author, :class_name => "User", index: true
  embeds_many :comments

  #validations
  validates_length_of :content, :maximum => 1000

  before_save :sync_desire

  def item
    @item ||= (place || product || recipe || tuan)
  end

  def name
    item ? item.name : ""
  end

  def get_image_url(version = nil)
    pic_url = nil
    pic_url = item.get_image_url(version) if item
    pic_url.present? ? pic_url : "/assets/not_found.png"
  end

  def identity
    item ? item.id.to_s : ""
  end

  #def can_vote?(user)
  #  user.present? && (!self.desire.vote_ids.include?(user.id)) && (self.author != user)
  #end

  private

  def sync_desire
    if self.new_record? && self.desire
      self.desire.save
    end
  end

end