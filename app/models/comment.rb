class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content

  #Relationships
  embedded_in :review
  belongs_to :user

end