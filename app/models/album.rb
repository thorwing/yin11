class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Votable
  can_like

  field :title
  field :description
  field :priority, :type => Integer, :default => 0
  field :cover_id

  attr_accessible :title, :description, :author_id

  #scopes
  scope :recommended, where(:priority.gt => 0)

  #relationships
  has_one :image
  has_and_belongs_to_many :reviews
  belongs_to :author, :class_name => "User"
  embeds_many :comments

  #validations
  validates_presence_of :title
  validates_length_of :title, :maximum => 20
  validates_length_of :description, :maximum => 400

  def items
    self.reviews.desc(:votes)
  end

  def get_cover_url(version = nil)
    image_url = nil
    if cover_id
      image = Image.first(conditions: {id: cover_id})
      image_url = image.picture_url(version) if image
    end

    unless image_url
      image = self.reviews.first{|r| r.get_review_image_url(version).present?}
      image_url = (image ? image.get_review_image_url(version) : '')
    end

    image_url
  end

end
