class Tip
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :content
  field :type, :type => Integer, :default => 0

  #cached values
  field :votes, :type => Integer, :default => 0
  field :fan_ids, :type => Array, :default => []
  field :hater_ids, :type => Array, :default => []

  #relationships
  has_many :revisions
  has_and_belongs_to_many :participators, :class_name => "User"
  has_and_belongs_to_many :tags

  attr_accessible :title, :content

  validates_uniqueness_of :title
  validates_presence_of :title, :message => I18n.translate("tips.title_presence_validate_msg")
  validates_length_of :title, :minimum => 2, :maximum => 20, :message => I18n.translate("tips.title_length_validate_msg", :min => 2, :max => 20)
  validates_presence_of :content
  validates_length_of :content, :maximum => 140, :message => I18n.translate("tips.content_length_validate_msg", :max => 140)
  validates_inclusion_of :type, :in => 1..2

  HANDLE_TIP = 1
  EXAM_TIP =  2

end
