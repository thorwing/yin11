class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  field :caption
  field :description
  #cached fields
  field :alone, type: Boolean, default: true
  field :waterfall_width
  field :waterfall_height
  mount_uploader :picture, PictureUploader

  attr_accessible :picture, :remote_picture_url, :caption, :description

  #relationships
  belongs_to :product
  belongs_to :review
  belongs_to :topic
  belongs_to :step
  belongs_to :ingredient
  belongs_to :album

  #validations
  validates_presence_of :picture

  #callback
  before_save :sync_status
  before_save :saving

  #scopes
  scope :lonely, where(alone: true)

  private

  def sync_status
    self.alone = product_id.blank? && review_id.blank? && topic_id.blank? && step_id.blank?
    true #return true for the callback function
  end

  def saving
    geometry = self.picture.waterfall.geometry
    if (!geometry.nil?)
      self.waterfall_width = geometry[0]
      self.waterfall_height = geometry[1]
    end
  end

end