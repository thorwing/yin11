class Tuan
  include Mongoid::Document
  include Mongoid::Timestamps
  include Imageable
  include Votable

  field :website
  field :identity
  field :url
  field :name
  field :price, type: Float, default: 0
  field :value, type: Float, default: 0
  field :rebate, type: Float, default: 0
  field :city
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :image_url

  has_one :image

  #relationships
  #has_and_belongs_to_many :places, index: true
  embeds_many :comments
  has_many :solutions

  #validations
  validates :url, presence: true, uniqueness: true

  def expired?
    self.end_time < DateTime.now
  end

  def price_as_money_string
    price ? format('%.2f', price) : ''
  end

  def value_as_money_string
    value ? format('%.2f', value) : ''
  end

  #overwrite
  def get_image_url(version = nil, index = 0)
    image_url
  end

end
