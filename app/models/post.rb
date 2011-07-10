class Post
  include Mongoid::Document
  field :title, :type => String
  field :content, :type => String

  #relationships
  belongs_to :group
  embeds_many :comments

  attr_accessible :title, :content, :group_id

  #validations
  validates_presence_of :title, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.title") )
  validates_length_of :title, :maximum => 30, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.title"),
                                                          :max => 30)
  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :maximum => 1000, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.content"),
                                                          :max => 100)
end
