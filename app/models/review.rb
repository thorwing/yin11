class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :comment

  #cached values
  field :food_id
  field :vendor_id, :type => BSON::ObjectId

  #Relationships
  belongs_to :product
  has_and_belongs_to_many :references, :class_name => "WikiPage"

  embeds_many :checkpoints
  validates_associated :checkpoints
  accepts_nested_attributes_for :checkpoints, :reject_if => lambda { |a| a[:display_title].blank? }, :allow_destroy => true

  attr_reader :reference_tokens
  def reference_tokens=(ids)
    self.reference_ids = ids.split(",")

    self.reference_ids.each do |id|
      page = WikiPage.find(id)
      page.check_point_ids ||= []
      page.check_point_ids << self.id
      page.save;
    end
  end

  attr_reader :food, :vendor
  def food=(food_name)
    if food_name.present?
      food = Food.first(conditions: {name: food_name})
      self.food_id = food.id
    end
  end

  def vendor=(vendor_name)

  end
end
