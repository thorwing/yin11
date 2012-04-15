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
  field :recipes_count, type: Integer, default: 0
  field :products_count, type: Integer, default: 0
  field :tuans_count, type: Integer, default: 0
  field :places_count, type: Integer, default: 0

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
    #total = 0
    #max = 0
    count = 0
    recipes = 0
    products = 0
    tuans = 0
    places = 0

    valid_solutions.each do |s|
      #total += s.score
      #max = s.score if votes > max

      case s.item.class.name
        when "Recipe"
          recipes += 1
          count += 1
        when "Product"
          products += 1
          count += 1
        when "Tuan"
          unless s.item.expired?
            count += 1
            tuans += 1
          end
        when "Place"
          places += 1
          count += 1
      end
    end
    #self.solved = total >= DESIRE_SOLVED_BAR_COUNT && ((max.to_f / total.to_f) >= DESIRE_SOLVED_BAR_RATIO)
    self.solutions_count = count
    self.recipes_count = recipes
    self.products_count = products
    self.tuans_count = tuans
    self.places_count = places
  end

end
