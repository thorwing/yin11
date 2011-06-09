class Opinion
  include Mongoid::Document
  include Mongoid::Timestamps
  include AssociatedModels
  include Informative

  scope :in_days_of, ->(days_in_number) {where(:created_at.gt => days_in_number.days.ago )}
  scope :about, ->(food) {any_in(food_ids: [food.is_a?(Food) ? food.id : food])}
#  scope :in_city, ->(city) {any_in(city_ids: [city.is_a?(City) ? city.id : city])}
#  scope :not_in_city, ->(city) {not_in(city_ids: [city.is_a?(City) ? city.id : city])}

  field :reported_on, :type => DateTime

  def reported_on_string
    self.reported_on.strftime('%m/%d/%Y')
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
  has_and_belongs_to_many :foods
  belongs_to :vendor
  belongs_to :author, :class_name => "User"

  tokenize_many :foods
  tokenize_one :vendor

  attr_accessible :reported_on, :reported_on_string
  #override the settings in Informative
  validates_length_of :content, :maximum => 10000, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.content"),
                                                                           :max => 10000)
end