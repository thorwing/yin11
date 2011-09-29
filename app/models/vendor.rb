class Vendor
  include Mongoid::Document
  include Available
  include Locational
  include Followable

  field :name
  field :verified, :type => Boolean, :default => false
  field :category
  field :sub_category

  attr_accessible :name, :category, :sub_category

  scope :of_city, lambda { |city_name| where(:city => city_name)}

  #Relationships
  has_many :reviews
  has_many :reports
  belongs_to :creator, :class_name => "User"
  embeds_many :feeds

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 30
  validates_presence_of :city
  validates_presence_of :street
  validates_uniqueness_of :full_name
  validates_inclusion_of :category, :in => VendorCategories.get_values, :allow_nil => true

  def full_name
    (name.nil? ? "" : name.strip) + " (" + address + ")"
  end

  def good_reviews_in(days)
    self.reviews.in_days_of(days).where(:faults => []).all
  end

  def bad_reviews_in(days)
    self.reviews.in_days_of(days).excludes(:faults => []).all
  end

  def get_feeds
    if self.respond_to?(:feeds)
      self.feeds
    else
      nil
    end
  end

end
