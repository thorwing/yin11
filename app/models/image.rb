class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  field :caption
  mount_uploader :image, ImageUploader

  attr_accessible :image, :remote_image_url, :description

  #relationships
  belongs_to :article
  belongs_to :review
  belongs_to :tip

end