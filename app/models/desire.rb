class Desire
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Imageable
  include Feedable
  include SilverSphinxModel

  field :content
  field :priority, :type => Integer, :default => 0
  field :history_admirer_ids, :type => Array, :default => []
  field :solved, :type => Boolean, :default => false

  search_index(:fields => [:content, :tags],
                :attributes => [:created_at])

  attr_accessible :content, :priority

  #scopes
  scope :enabled, where(:priority.gte => 0)
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

  #def latest_user_solution
  #  solutions.excludes(author_id: nil).first(sort: [[ :created_at, :desc ]])
  #end

  def voter_ids
    @voter_ids ||= self.solutions.inject([]){|memo, s| memo | s.voter_ids }
  end

  def votes_count
    @votes_count ||= self.solutions.inject(0){|sum, s| sum + s.voter_ids.size }
  end

  def best_solution
    @best_solution ||= self.solutions.max_by {|s| s.votes.size}
    @best_solution
  end

  def check_solutions
    unless self.new_record?
      was_solved = self.solved
      total = 0
      max = 0
      self.solutions.each do |s|
        size = s.votes.size
        total += size
        max = size if size > max
      end
      enough_votes = total >= DESIRE_SOLVED_BAR_COUNT
      self.solved = enough_votes && ((max.to_f / total.to_f) >= DESIRE_SOLVED_BAR_RATIO)
      self.save if self.solved != was_solved
    end
  end

end
