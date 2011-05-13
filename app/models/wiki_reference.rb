class WikiReference
  include Mongoid::Document
  field :link_type, :type => String

  #Relationships
  belongs_to :page, :class_name => "WikiPage"

end
