class Vendor
  include Mongoid::Document
  include Mongoid::Timestamps
  include Available
  include Locational
  include Followable
  include SilverSphinxModel

  field :name
  field :verified, :type => Boolean, :default => false
  field :category
  field :sub_category
  field :is_tmall, :type => Boolean

  search_index(:fields => [:name],
              :attributes => [:updated_at, :created_at])

  attr_accessible :name, :category, :sub_category

  scope :of_city, lambda { |city_name| where(:city => city_name)}

  #Relationships
  has_many :reviews
  has_many :reports
  has_many :products
  belongs_to :creator, :class_name => "User"
  embeds_many :feeds

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 30
  #validates_presence_of :city
  #validates_presence_of :street
  validates_uniqueness_of :full_name
  validates_inclusion_of :category, :in => VendorCategories.get_values, :allow_nil => true

  def full_name
    (name.nil? ? "" : name.strip) + " (" + address + ")"
  end

end
