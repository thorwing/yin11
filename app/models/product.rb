class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Available
  include Imageable
  include Votable

  field :name
  field :price, :type => Float
  field :normal_url
  field :refer_url
  field :iid

  field :commission, :type => Float
  field :commission_rate, :type => Float
  field :commission_num, :type => Integer
  field :commission_volume, :type => Float
  field :item_location
  field :volume, :type => Integer

  attr_accessible :iid

  #relationships
  embeds_many :comments
  belongs_to :vendor, index: true
  has_one :image
  has_and_belongs_to_many :catalogs, index: true
  has_many :solutions

  #validators
  validates_presence_of :name
  #60 bytes limited by tabao
  validates_length_of :name, :maximum => 120
  validates_presence_of :vendor
  validates_uniqueness_of :iid

  def url
    self.refer_url.present? ? self.refer_url : self.normal_url
  end

  def price_as_money_string
    price ? format('%.2f', price) : ''
  end

end
