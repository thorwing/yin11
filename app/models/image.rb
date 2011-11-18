class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  field :caption
  field :description
  mount_uploader :picture, PictureUploader

  attr_accessible :picture, :remote_picture_url, :caption, :description

  #relationships
  belongs_to :article
  belongs_to :product
end