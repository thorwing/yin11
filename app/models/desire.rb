class Desire
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Imageable
  include Feedable
  include Recommendable
  include SilverSphinxModel

  field :content
  field :history_admirer_ids, type: Array, default: []
  field :solved, type: Boolean, default: false
  field :via_product, type: Boolean, default: false
  field :via_recipe, type: Boolean, default: false

  search_index(fields: [:content, :tags],
                attributes: [:created_at])

  attr_accessible :content, :via_product, :via_recipe

  #relationships
  has_many :images
  has_many :reviews
  has_many :solutions
  belongs_to :author, class_name: "User", index: true
  has_and_belongs_to_many :admirers, class_name: "User", inverse_of: "admired_desires", index: true
  has_and_belongs_to_many :albums, index: true
  belongs_to :place, index: true
  embeds_many :comments

  #validations
  validates_presence_of :author
  validates_length_of :content, maximum: MAX_DESIRE_CONTENT_LENGTH

  #def latest_user_solution
  #  solutions.excludes(author_id: nil).first(sort: [[ :created_at, :desc ]])
  #end

  def valid_solutions
    @valid_solutions ||= self.solutions.reject{|s| s.item.nil? }.uniq{|s| s.identity}
  end

  def voter_ids
    @voter_ids ||= valid_solutions.inject([]){|memo, s| memo | s.voter_ids }
  end

  def fans_count
    @fans_count ||= valid_solutions.inject(0){|sum, s| sum + s.fan_ids.size }
  end

  def best_solution
    @best_solution ||= valid_solutions.max_by {|s| s.votes.size}
    @best_solution
  end

  def check_solutions
    unless self.new_record?
      was_solved = self.solved
      total = 0
      max = 0
      valid_solutions.each do |s|
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
