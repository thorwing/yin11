class Review
  include Mongoid::Document
  include Mongoid::Timestamps
  include AssociatedModels
  include Available
  include Votable
  include Feedable
  include Imageable

  field :content

  attr_accessible :content, :images_attributes, :product_ids, :recipe_ids, :topic_id

  #scopes
  scope :in_days_of, lambda { |days_in_number| where(:created_at.gt => days_in_number.days.ago) }

  #relationships
  has_and_belongs_to_many :products
  belongs_to :recipe
  belongs_to :topic
  embeds_many :comments
  belongs_to :author, :class_name => "User"
  has_many :images

  #override the settings in Informative
  validates_presence_of :content
  validates_length_of :content, :maximum => 280
  validates_presence_of :author

  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:image].blank? && i[:remote_picture_url].blank? }, :allow_destroy => true

  def is_recent?
    self.created_at >= ITEM_MEASURE_RECENT_DAYS.days.ago ? true : false
  end

  def is_popular?
    self.votes >= ITEM_MEASURE_POPULAR ? true : false
  end

  def get_imageable_item
    if self.images.empty?
      if self.products.size > 0
        return self.products.first
      elsif self.recipe
        return self.recipe
      end
    end

    self
  end

  def get_review_image_url(version = nil)
    imageable = self.get_imageable_item
    imageable.get_image_url(version)
  end

  def get_review_image_height(version = nil)
    imageable = self.get_imageable_item
    imageable.get_image_height(version)
  end

  def get_images_with_objects(version = nil)
    images = self.images.map{|i| {picture_url: i.picture_url(version), object: nil }} || []

    if self.products.size > 0
      images += self.products.map {|p| {picture_url: p.get_image_url(version), object: p} }
    elsif self.recipe
      images << {picture_url: self.recipe.get_image_url(version), object: self.recipe}
    end

    images
  end
end
