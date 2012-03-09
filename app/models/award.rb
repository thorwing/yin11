class Award
  include Mongoid::Document
  include Mongoid::Timestamps
  include Recommendable
  include Imageable

  field :name
  field :description
  field :price, :type => Float
  field :total_volume, :type => Integer
  field :left_volume, :type => Integer
  field :score, type: Integer
  field :due_date, type: DateTime
  field :closed, type: Boolean, default: false

  before_save :sync_volume

  attr_accessible :name, :description, :price, :due_date, :closed, :score, :total_volume

  #scopes
  scope :opening, where(:closed => false)

  #relationships
  has_and_belongs_to_many :winners, class_name: "User", inverse_of: "awards", index: true
  has_one :image
  embeds_many :comments

  #validations
  validates_presence_of :name
  validates_presence_of :score
  validates_presence_of :total_volume
  validates_numericality_of :score, greater_than: 0
  validates_presence_of :due_date

  def price_as_money_string
    price ? format('%.2f', price) : ''
  end

  private

  def sync_volume
    self.left_volume = self.total_volume if self.new_record?
  end

end