class Profile
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  #food names
  field :watching_foods, :type => Array, :default => []
  field :receive_mails, :type => Boolean, :default => true

  mount_uploader :avatar, AvatarUploader

  #relationships
  embedded_in :user
  embeds_many :addresses

  accepts_nested_attributes_for :addresses, :reject_if => lambda { |a| a[:point].blank? }, :allow_destroy => true
  attr_accessible :receive_mails, :address_attributes, :avatar

  validates_associated :addresses

  def add_foods(foods = [])
    for food in foods
      self.watching_foods << food unless self.watching_foods.include?(food)
    end
  end

end