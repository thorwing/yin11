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

end