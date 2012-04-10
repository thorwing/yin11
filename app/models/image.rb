class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  field :caption
  field :description
  #cached fields
  field :waterfall_width
  field :waterfall_height
  field :updated, type: Boolean, default: false
  mount_uploader :picture, PictureUploader

  attr_accessible :picture, :remote_picture_url, :caption, :description

  #relationships
  belongs_to :product, index: true
  belongs_to :topic, index: true
  belongs_to :step, index: true
  belongs_to :ingredient, index: true
  belongs_to :album, index: true
  belongs_to :desire, index: true
  belongs_to :award, index: true
  belongs_to :recipe, index: true
  belongs_to :tuan, index: true

  #validations
  validates_presence_of :picture

  #callback
  before_save :saving

  #scopes
  scope :lonely, where(alone: true)

  private

  def saving
    geometry = self.picture.waterfall.geometry
    if (!geometry.nil?)
      self.waterfall_width = geometry[0]
      self.waterfall_height = geometry[1]
    end
  end

end