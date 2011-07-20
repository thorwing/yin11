class Report
  include Mongoid::Document
  field :content
  field :email

  attr_accessible :content, :email

  #relationships
  belongs_to :vendor

  validates_presence_of :content
  validates_length_of :content, :maximum => 500
  validates :email, :email_format => true, :if => Proc.new{|model| model.email.present?}

end