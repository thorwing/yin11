class Feed
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :target_type
  field :target_id
  field :target_operation

  #relationships
  embedded_in :tag
  embedded_in :vendor
  embedded_in :user
  embedded_in :product
  embedded_in :recipe
  embedded_in :group

  #validations
  def self.operations
    ["create", "update"]
  end

  validates_inclusion_of :target_operation, :in => Feed.operations

  def identity
    #for different operations,  only the latest one matters
    [target_type, target_id].join(' ')
  end

  def cracked?
    item.blank? || author.blank?
  end

  def item
    @item ||= get_item
    @item
  end

  def content
    @content ||= get_content
    @content
  end

  def author
    @author ||= get_author
    @author
  end

  def picture_url(version = nil)
    if item.is_a?(Review)
      item.get_review_image_url(version)
    elsif item.respond_to?(:get_image_url)
      item.get_image_url(version)
    else
      nil
    end
  end

  def picture_height(version = nil)
    if item.is_a?(Review)
      item.get_review_image_height(version)
    elsif item.respond_to?(:get_image_url)
      item.get_image_height(version)
    else
      0
    end
  end

  private

  def get_item
    begin
      eval("#{target_type}.find(\"#{target_id}\")")
    rescue
      nil
    end
  end

  def get_content
    if item
      [:title, :name, :content].each do |field|
        return item.send(field) if item.respond_to?(field)
      end
    end

    return ''
  end

  def get_author
    if item && item.respond_to?(:author)
      return item.author
    else
      nil
    end
  end

end