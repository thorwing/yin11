class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Ancestry
  has_ancestry

  field :content
  field :ancestry
  index :ancestry

  #Relationships
  embedded_in :review
  embedded_in :article
  belongs_to :user

  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content"))
  validates_length_of :content, :maximum => 140, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.content"),
  :max => 140)

end