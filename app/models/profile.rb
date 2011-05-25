class Profile
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  #food names
  field :watching_foods, :type => Array, :default => []
  field :display_articles, :type => Boolean, :default => true
  field :display_reviews, :type => Boolean, :default => true
  field :receive_mails, :type => Boolean, :default => true

  mount_uploader :avatar, AvatarUploader

  #relationships
  embedded_in :user
  embeds_one :address

  accepts_nested_attributes_for :address, :allow_destroy => true
  attr_accessible :display_articles, :display_reviews, :receive_mails, :address_attributes, :avatar

  validates_associated :address

  #Others
  after_initialize :build_address

  def build_address
    self.address ||= Address.new
  end

  def add_foods(foods = [])
    for food in foods
      self.watching_foods << food unless self.watching_foods.include?(food)
    end
  end

end