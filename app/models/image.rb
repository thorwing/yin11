class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  field :caption
  field :description
  mount_uploader :image, ImageUploader

  attr_accessible :image, :remote_image_url, :caption, :description

  #relationships
  belongs_to :info_item
  belongs_to :product
end