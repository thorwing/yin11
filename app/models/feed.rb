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
  embedded_in :group

  #validations
  def self.operations
    ["create", "update"]
  end

  validates_inclusion_of :target_operation, :in => Feed.operations

  def identity
    [target_type, target_id, target_operation].join(' ')
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

  def picture_url(thumb = true)
    if item.is_a?(Review)
      item.get_review_image_url(thumb)
    elsif item.respond_to?(:get_picture_url)
      item.get_image_url(thumb, 0, false)
    else
      ''
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
    [:title, :name, :content].each do |field|
      return item.send(field) if item.respond_to?(field)
    end

    return ''
  end

  def get_author
    if item.respond_to?(:author)
      return item.author
    else
      nil
    end
  end

end