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

  attr_accessible :title, :description, :author_id, :priority

  #scopes
  scope :recommended, where(:priority.gt => 0)

  #relationships
  has_one :image
  has_and_belongs_to_many :reviews
  has_and_belongs_to_many :desires
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
      if self.desires.size > 0
        imagable = self.desires.first{|r| r.get_image_url(version).present?}
        image_url = imagable.get_image_url(version) if imagable
      elsif self.reviews.size > 0
        imagable = self.reviews.first{|r| r.get_review_image_url(version).present?}
        image_url = imagable.get_review_image_url(version) if imagable
      end
    end

    image_url ? image_url : "assets/not_found.png"
  end

  def get_image_urls(limit, version = nil)
    #the version may not actually be the version of cover to use, but we use it to compare. e.g. :waterfall instead of thumb
    cover_url = get_cover_url(version)
    #get one more in case it's cover
    image_urls = self.reviews.limit(limit + 1).map{|r| r.get_review_image_url(version)}.reject{|url| url == cover_url || url.blank?}
    image_urls.take(limit)
  end

end
