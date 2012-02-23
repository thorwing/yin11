class Desire
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Imageable
  include Feedable

  field :content
  field :priority, :type => Integer, :default => 0
  field :solutions_count, :type => Integer, :default => 0
  field :history_admirer_ids, :type => Array, :default => []

  attr_accessible :content, :priority

  #scopes
  scope :recommended, where(:priority.gt => 0)

  #relationships
  has_many :images
  has_many :reviews
  has_many :solutions
  belongs_to :author, :class_name => "User", index: true
  has_and_belongs_to_many :admirers, :class_name => "User", :inverse_of => "admired_desires", index: true
  has_and_belongs_to_many :albums, index: true
  belongs_to :place, index: true
  embeds_many :comments

  #validations
  validates_presence_of :author
  validates_length_of :content, :maximum => MAX_DESIRE_CONTENT_LENGTH

  def has_solution?
    result = false
    if self.place
      result = true
    elsif self.reviews.count(conditions: {:votes.gt => 3}) > 0
      result = true
    end

    result
  end

  def voter_ids
    @voter_ids ||= self.solutions.inject([]){|memo, s| memo | s.voter_ids }
  end

  def votes_count
    self.solutions.inject(0){|sum, s| sum + s.voter_ids.size }
  end

end
