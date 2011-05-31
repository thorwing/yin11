class Review
  include Mongoid::Document
  include AssociatedModels
  include Informative

  scope :in_days_of, ->(days_in_number) {where(:created_at.gt => days_in_number.days.ago )}
  scope :about, ->(food) {where(food_id: food.is_a?(Food) ? food.id : food)}
#  scope :in_city, ->(city) {any_in(city_ids: [city.is_a?(City) ? city.id : city])}
#  scope :not_in_city, ->(city) {not_in(city_ids: [city.is_a?(City) ? city.id : city])}

  field :severity, :type => Integer, :default => 0

  #cached values
  field :vendor_name
  field :vendor_city
  field :vendor_street

  #Relationships
  has_and_belongs_to_many :foods
  belongs_to :vendor
  belongs_to :author, :class_name => "User"
  embeds_many :checkpoints

  accepts_nested_attributes_for :checkpoints,  :reject_if => lambda { |c| c[:name].blank? }, :allow_destroy => true

  tokenize_many :foods
  tokenize_one :vendor

  attr_accessible :severity, :vendor_name, :vendor_city, :vendor_street, :checkpoints_attributes

  before_save :update_vendor

  def update_vendor
    if self.vendor.nil?
      if self.vendor_name.present?
        self.vendor = Vendor.new
        self.vendor.name = self.vendor_name
        self.vendor.create_address(:city_id => self.vendor_city, :street => self.vendor_street)
        self.vendor.save
      end
    end
  end


#  embeds_many :checkpoints
#  validates_associated :checkpoints
#  accepts_nested_attributes_for :checkpoints, :reject_if => lambda { |a| a[:display_title].blank? }, :allow_destroy => true
#
#  attr_reader :reference_tokens
#  def reference_tokens=(ids)
#    self.reference_ids = ids.split(",")
#
#    self.reference_ids.each do |id|
#      page = WikiPage.find(id)
#      page.check_point_ids ||= []
#      page.check_point_ids << self.id
#      page.save;
#    end
#  end

end
