class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  field :title
  field :description

  attr_accessible :title, :description, :author_id

  #relationships
  has_one :image
  has_and_belongs_to_many :reviews
  belongs_to :author, :class_name => "User"
  embeds_many :comments

  #validations
  validates_presence_of :title
  validates_length_of :title, :maximum => 20
  validates_length_of :description, :maximum => 200

  def items
    self.reviews.desc(:votes)
  end

  def get_image_url(version = nil)
    image = self.reviews.first{|r| r.get_review_image_url(version).present?}
    image ? image.get_review_image_url(version) : ''
  end

end
