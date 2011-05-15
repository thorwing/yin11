class Review
  include Mongoid::Document
  include Mongoid::Timestamps
  include AssociatedModels

  field :content
  field :severity, :type => Integer, :default => 0

  #cached values
  field :vendor_name
  field :vendor_city
  field :vendor_street

  field :votes, :type => Integer, :default => 0
  field :fan_ids, :type => Array, :default => []
  field :hater_ids, :type => Array, :default => []

  #Relationships
  belongs_to :food
  belongs_to :vendor
  belongs_to :author, :class_name => "User"
  embeds_many :comments

  tokenize_one :food, :vendor

  #Validators
  validates_presence_of :food_id

  def title
    [self.author.login_name, I18n.translate("reviews.title_review"), self.vendor.try(:address).try(:city).try(:name), self.vendor.try(:address).try(:street),
    self.vendor.try(:name), I18n.translate("reviews.title_the"), self.food.try(:name), ":"].join(" ")
  end

  attr_accessible :content, :severity, :vendor_name, :vendor_city, :vendor_street

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
