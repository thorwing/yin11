class Profile
  include Mongoid::Document
  field :cared_foods, :type => Array, :default => []
  field :display_articles, :type => Boolean, :default => true
  field :display_reviews, :type => Boolean, :default => true
  field :receive_mails, :type => Boolean, :default => true

  #relationships
  embedded_in :user
  embeds_one :address

  def address_city
    self.address.city_id
  end
  def address_city=(city_id)
    self.address.city_id = city_id
  end

  attr_accessible :address_city

  validates_associated :address

  #Others
  after_initialize :build_address

  def build_address
    self.address ||= Address.new
  end

end