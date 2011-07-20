class Source
  include Mongoid::Document

  field :name, :type => String
  field :site, :type => String
  field :url, :type => String

  attr_accessible :name, :site, :url

  validates_presence_of :name
  validates_length_of :name, :maximum => 20
  validates_length_of :site, :maximum => 20
  validates_format_of :url, :with => URI::regexp(%w(http https)), :if => Proc.new { |model| !model.url.blank? }

  #Relationships
  belongs_to :article

end