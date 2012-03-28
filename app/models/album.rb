class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Votable
  include Recommendable

  field :title
  field :description
  field :cover_id
  field :desires_count, type: Integer, default: 0

  attr_accessible :title, :description, :author_id, :priority

  #relationships
  has_one :image
  has_and_belongs_to_many :desires, index: true
  belongs_to :author, :class_name => "User", index: true
  embeds_many :comments

  #validations
  validates_presence_of :title
  validates_length_of :title, :maximum => 20
  validates_length_of :description, :maximum => 400

  before_save do |doc|
    doc.desires_count = doc.desires.count
  end

  def get_cover_url(version = nil)
    image_url = nil
    if cover_id
      image = Image.first(conditions: {id: cover_id})
      image_url = image.picture_url(version) if image
    end

    unless image_url
      imagable = self.desires.first{|r| r.get_image_url(version).present?}
      image_url = imagable.get_image_url(version) if imagable
    end

    image_url ? image_url : "/assets/not_found.png"
  end

  #proxy
  def get_image_url(version = nil)
    get_cover_url(version)
  end

  def get_image_urls(limit, version = nil)
    #the version may not actually be the version of cover to use, but we use it to compare. e.g. :waterfall instead of thumb
    cover_url = get_cover_url(version)
    #get one more in case it's cover
    image_urls = self.desires.limit(limit + 1).map{|d| d.get_image_url(version)}.reject{|url| url == cover_url || url.blank?}
    image_urls.take(limit)
  end

end
