class Revision
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, :type => String

  #Relationships
  embedded_in :tip
  belongs_to :author, :class_name => "User"

  attr_accessible :content

  validates_presence_of :content
  validates_length_of :content, :maximum => 140, :message => I18n.translate("tips.content_length_validate_msg", :max => 140)

end
