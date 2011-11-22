class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include AssociatedModels
  include Taggable
  include Followable
  include Votable
  include Available
  include Imageable
  include SilverSphinxModel

  field :name
  field :price, :type => Float
  field :weight, :type => Float
  field :producer
  field :area
  field :authenticated
  field :description
  field :details
  field :url
  #for indexing of search
  field :vendor_name

  field :editor_score, :type => Integer, :default => 0

  field :original_name

  search_index(:fields => [:name, :vendor_name],
              :attributes => [:updated_at, :created_at])

  attr_accessible :name, :url, :price, :weight, :vendor_id, :editor_score

  #scopes
  scope :via_editor, order_by([:editor_score, :desc])

  #relationships
  embeds_many :comments
  belongs_to :vendor
  tokenize_one :vendor
  has_one :image
  has_many :reviews
  has_and_belongs_to_many :catalogs
  embeds_many :feeds

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 100
  validates_presence_of :vendor
  validates_numericality_of :editor_score, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  before_save :sync_vendor

  def sync_vendor
    self.vendor_name ||= self.vendor.name if self.vendor_id
  end

  def price_as_money_string
    format('%.2f', price)
  end

end
