class Desire
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Imageable
  include Feedable

  field :content
  #field :admired_count, :type => Integer, :default => 0
  #field :admirers_ids, :type => Array, :default => []
  field :priority, :type => Integer, :default => 0
  field :solutions_count, :type => Integer, :default => 0
  field :history_admirer_ids, :type => Array, :default => []

  attr_accessible :content, :priority

  #scopes
  scope :recommended, where(:priority.gt => 0)

  #relationships
  has_many :images
  has_many :reviews
  belongs_to :author, :class_name => "User"
  has_and_belongs_to_many :admirers, :class_name => "User", :inverse_of => "admired_desires", :index => true
  has_and_belongs_to_many :albums
  belongs_to :place
  #embeds_many :comments

  #validations
  validates_presence_of :author
  validates_length_of :content, :maximum => MAX_DESIRE_CONTENT_LENGTH

  before_save :sync_counts

  #TODO
  def get_solutions_count
    self.solutions_count = self.reviews.count(conditions: {:votes.gt => 3})
  end

  private

  def sync_counts
    self.solutions_count = self.reviews.count(conditions: {:votes.gt => 3})
  end
end
