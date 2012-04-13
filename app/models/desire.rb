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
  field :solutions_count, type: Integer, default: 0

  search_index(fields: [:content, :tags],
                attributes: [:created_at])

  attr_accessible :content

  #relationships
  has_many :images
  has_many :solutions
  belongs_to :author, class_name: "User", index: true
  has_and_belongs_to_many :admirers, class_name: "User", inverse_of: "admired_desires", index: true
  has_and_belongs_to_many :albums, index: true
  belongs_to :place, index: true
  embeds_many :comments

  #validations
  validates_presence_of :author
  validates_length_of :content, maximum: MAX_DESIRE_CONTENT_LENGTH

  before_save :check_solutions

  #def latest_user_solution
  #  solutions.excludes(author_id: nil).first(sort: [[ :created_at, :desc ]])
  #end

  def valid_solutions
    self.solutions.reject{|s| s.item.nil? }.uniq{|s| s.identity}
  end

  #def fans_count
  #  @fans_count ||= valid_solutions.inject(0){|sum, s| sum + s.fan_ids.size }
  #end

  #def best_solution
  #  @best_solution ||= valid_solutions.max_by {|s| s.votes.size}
  #  @best_solution
  #end

  private

  def check_solutions
    total = 0
    max = 0
    valid_solutions.each do |s|
      votes = s.fan_ids.size
      total += votes
      max = votes if votes > max
    end
    self.solved = total >= DESIRE_SOLVED_BAR_COUNT && ((max.to_f / total.to_f) >= DESIRE_SOLVED_BAR_RATIO)
    self.solutions_count = valid_solutions.size

    #self.save if self.changed?
  end

end
