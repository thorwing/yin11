class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  field :caption
  field :description
  #cached fields
  field :alone, type: Boolean, default: true
  mount_uploader :picture, PictureUploader

  attr_accessible :picture, :remote_picture_url, :caption, :description

  #relationships
  belongs_to :article
  belongs_to :product
  belongs_to :review
  belongs_to :topic
  belongs_to :step
  belongs_to :ingredient

  #validations
  validates_presence_of :picture

  #callback
  before_save :sync_status

  #scopes
  scope :lonely, where(alone: true)

  private

  def sync_status
    alone = article_id.blank? && product_id.blank? && review_id.blank? && topic_id.blank?
  end

end