class WikiRevision
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content

  #Relationships
  belongs_to :page, :class_name => "WikiPage"

end
