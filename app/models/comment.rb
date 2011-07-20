class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Ancestry
  has_ancestry

  field :content, :type => String

  #Relationships
  embedded_in :review
  embedded_in :article
  embedded_in :tip
  embedded_in :post
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :content
  validates_length_of :content, :maximum => 1000

end