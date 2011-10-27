class Review < InfoItem
  field :worth, :type => Boolean

  #relationships
  belongs_to :product

  #override the settings in Informative
  validates_length_of :content, :maximum => 3000


end
