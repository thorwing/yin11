class Product
  include Mongoid::Document
  include AssociatedModels
  include Taggable
  include Followable
  include Votable
  include Available

  field :name
  field :price, :type => Float
  field :weight, :type => Float
  field :producer
  field :area
  field :authenticated
  field :description
  field :url

  field :recommended_score, :type => Integer, :default => 0

  field :original_name

  attr_accessible :name, :url, :price, :weight, :vendor_id, :category_id, :recommended_score

  #relationships
  embeds_many :comments
  belongs_to :vendor
  tokenize_one :vendor
  has_one :image
  belongs_to :category
  has_many :reviews

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 100
  validates_presence_of :vendor
  validates_numericality_of :recommended_score, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  def price_as_money_string
    format('%.2f', price)
  end

end
