class InfoItem
  include Mongoid::Document
  include AssociatedModels
  include Available

  scope :in_days_of, ->(days_in_number) {where(:created_at.gt => days_in_number.days.ago )}
  scope :about, ->(food) {any_in(food_ids: [food.is_a?(Food) ? food.id : food])}
  #  scope :in_city, ->(city) {any_in(city_ids: [city.is_a?(City) ? city.id : city])}
  #  scope :not_in_city, ->(city) {not_in(city_ids: [city.is_a?(City) ? city.id : city])}

  field :title
  field :content
  field :reported_on, :type => DateTime
  field :faults, :type => Array, :default => []

  field :votes, :type => Integer, :default => 0
  field :fan_ids, :type => Array, :default => []
  field :hater_ids, :type => Array, :default => []

  def reported_on_string
    reported_on ||= DateTime.now
    reported_on.strftime('%m/%d/%Y')
  end

  def reported_on_string=(reported_on_str)
    self.reported_on = DateTime.parse(reported_on_str)
    rescue ArgumentError
      @reported_on_invalid = true
  end

  def validate
    errors.add(:reported_on, "is invalid") if @reported_on_invalid
  end

  #Relationships
  embeds_many :comments
  has_and_belongs_to_many :foods
  has_and_belongs_to_many :toxin
  has_many :images
  belongs_to :vendor
  belongs_to :author, :class_name => "User"
  tokenize_many :foods
  tokenize_one :vendor

  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:image].blank? && i[:remote_image_url].blank? }, :allow_destroy => true

  attr_accessible :title, :content, :reported_on_string, :faults, :images_attributes

  validates_presence_of :title, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.title") )
  validates_length_of :title, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.title"),
                                                          :max => 20)
  #TODO
  #validates_presence_of :images

end