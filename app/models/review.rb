class Review
  include Mongoid::Document
  include Mongoid::Timestamps
  include AssociatedModels
  include Available
  include Feedable
  include Imageable
  include Votable
  can_like

  field :content

  attr_accessible :content, :images_attributes, :product_ids, :recipe_ids, :album_ids, :desire_id

  #scopes
  scope :in_days_of, lambda { |days_in_number| where(:created_at.gt => days_in_number.days.ago) }

  #relationships
  has_and_belongs_to_many :products
  has_and_belongs_to_many :recipes
  embeds_many :comments
  belongs_to :author, :class_name => "User"
  belongs_to :desire
  has_many :images
  has_and_belongs_to_many :albums

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
      elsif self.recipes.size > 0
        return self.recipes.first
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
    images = self.images.map{|i| {picture_url: i.picture_url(version), picture_height: (version == :waterfall && i.waterfall_height.present?) ? i.waterfall_height.to_i : 200, object: nil }} || []

    if self.products.size > 0
      images += self.products.map {|p| {picture_url: p.get_image_url(version), picture_height: p.get_image_height(version), object: p} }
    elsif self.recipes.size > 0
      images += self.recipes.map {|r| {picture_url: r.get_image_url(version), picture_height: r.get_image_height(version), object: r} }
    end

    images
  end

  def get_linked_items
    #images = self.images.map{|i| {picture_url: i.picture_url(version), picture_height: (version == :waterfall && i.waterfall_height.present?) ? i.waterfall_height.to_i : 200, object: nil }} || []
    data = self.products + self.recipes
    data.compact.reject{|item| item.get_image_url.blank?}
  end
end
