class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  field :caption, :type => String
  field :description, :type => String
  mount_uploader :image, ImageUploader

  attr_accessible :image, :remote_image_url, :description

  #relationships
  belongs_to :info_item
end