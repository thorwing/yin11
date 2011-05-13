class WikiPage
  include Mongoid::Document
  field :title
  field :content

  #Validators
  validates_uniqueness_of :title

  #Relationships
  belongs_to :category, :class_name => "WikiCategory"
  has_many :revisions, :class_name => "WikiRevision"

  def get_section(section_title)

  end

end
