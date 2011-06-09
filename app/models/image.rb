class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  field :caption
  field :description
  mount_uploader :image, ImageUploader

  attr_accessible :image, :remote_image_url, :description

  #relationships
  belongs_to :article
  belongs_to :opinion
  belongs_to :tip

end