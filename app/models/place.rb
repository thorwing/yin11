class Place
  include Mongoid::Document
  include Gmaps4rails::ActsAsGmappable
  include Votable

  field :name
  field :verified, :type => Boolean, :default => false
  field :city
  field :street
  field :latitude, :type => Float
  field :longitude, :type => Float
  field :location, :type => Array, :geo => true, :lat => :latitude, :lng => :longitude

  attr_accessible :name, :city, :street, :latitude, :longitude

  index [[ :location, Mongo::GEO2D ]], :min => -180, :max => 180

  acts_as_gmappable :checker => :prevent_geocoding

  scope :of_city, lambda { |city_name| where(:city => city_name)}

  #Relationships
  embeds_many :comments
  has_many :desires
  belongs_to :creator, :class_name => "User"
  embeds_many :feeds

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 30
  validates_presence_of :street
  validates_presence_of :city

  #search_index(:fields => [:name,],
  #            :attributes => [:updated_at, :created_at])
  validates_uniqueness_of :name_with_address

  def name_with_address
    (name || "") + " (" + address + ")"
  end

  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.street}, #{self.city}, #{I18n.t("location.default_country")}"
  end

  def address
    [(self.city ? self.city : ""), (self.street ? self.street : "")].join(" ")
  end

  def prevent_geocoding
    #may create from seeds
    (new_record? && latitude.present? && longitude.present?) || street.blank?
  end

  def get_image_url(version = nil)
    desire = self.desires.first
    desire ? desire.get_image_url(version) : "not_found.png"
  end
end
