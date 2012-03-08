class Award
  include Mongoid::Document
  include Mongoid::Timestamps
  include Recommendable
  include Imageable

  field :name
  field :description
  field :price, :type => Float
  field :score, type: Integer
  field :due_date, type: DateTime
  field :closed, type: Boolean, default: false

  attr_accessible :name, :description, :price, :due_date, :closed, :score

  #scopes
  scope :opening, where(:closed => false)

  #relationships
  has_and_belongs_to_many :winners, class_name: "User", inverse_of: "awards", index: true
  has_one :image
  embeds_many :comments

  #validations
  validates_presence_of :name
  validates_presence_of :score
  validates_numericality_of :score, greater_than: 0
  validates_presence_of :due_date

  def price_as_money_string
    price ? format('%.2f', price) : ''
  end

end