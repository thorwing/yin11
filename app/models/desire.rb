class Desire
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Imageable
  include Feedable

  field :content
  field :priority, :type => Integer, :default => 0
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
    unless @result
      total = 0
      max = 0
      @best_solution = nil
      self.solutions.each do |s|
        size = s.votes.size
        total += size
        if size > max
          @best_solution = s
          max = size
        end
      end
      enough_votes = total >= DESIRE_SOLVED_BAR_COUNT
      @result = enough_votes && ((max.to_f / total.to_f) >= DESIRE_SOLVED_BAR_RATIO)
    end

    return @result, @best_solution
  end

  #def latest_user_solution
  #  solutions.excludes(author_id: nil).first(sort: [[ :created_at, :desc ]])
  #end

  def voter_ids
    @voter_ids ||= self.solutions.inject([]){|memo, s| memo | s.voter_ids }
  end

  def votes_count
    @votes_count ||= self.solutions.inject(0){|sum, s| sum + s.voter_ids.size }
  end

end
