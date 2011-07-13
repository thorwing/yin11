class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Locational

  field :name
  field :description

  #cached_values
  field :members_count, :type => Integer, :default => 0
  field :created_by, :type => String # id of the creator

  #relationships
  has_and_belongs_to_many :users
  has_many :posts

  attr_accessible :name, :description

  #validators
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.name"),
                                                                           :max => 20)
  validates_length_of :description, :maximum => 200, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.description"),
                                                                           :max => 200)

  def is_creator_by?(user)
    (user && user.id.to_s == self.created_by) ? true : false
  end

end