class Invitation
  include Mongoid::Document

  field :code
  key :code
  field :used, :type => Boolean, :default => false
  field :entitle_to
  field :invitee

  attr_accessible :code, :entitle_to

  validates :code, :presence => true, :uniqueness => true

end