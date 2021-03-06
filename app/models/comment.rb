class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Ancestry
  has_ancestry

  field :content, :type => String
  field :enabled, :type => Boolean, :default => true

  #Relationships
  embedded_in :review
  embedded_in :post
  embedded_in :recipe
  embedded_in :album
  embedded_in :place
  embedded_in :desire
  embedded_in :solution
  embedded_in :tuan
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :content
  validates_length_of :content, :maximum => 1000

end