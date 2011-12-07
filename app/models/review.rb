class Review
  include Mongoid::Document
  include Mongoid::Timestamps
  include AssociatedModels
  include Available
  include Votable
  include Feedable
  include Imageable

  field :content

  attr_accessible :content, :images_attributes, :product_id, :article_id, :topic_id

  #scopes
  scope :in_days_of, lambda { |days_in_number| where(:created_at.gt => days_in_number.days.ago) }

  #relationships
  belongs_to :product
  belongs_to :article
  belongs_to :topic
  embeds_many :comments
  belongs_to :author, :class_name => "User"
  has_many :images

  #override the settings in Informative
  validates_length_of :content, :maximum => 280
  validates_presence_of :author

  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:image].blank? && i[:remote_picture_url].blank? }, :allow_destroy => true

  def is_recent?
    self.created_at >= ITEM_MEASURE_RECENT_DAYS.days.ago ? true : false
  end

  def is_popular?
    self.votes >= ITEM_MEASURE_POPULAR ? true : false
  end

end
