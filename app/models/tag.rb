class Tag
  include Mongoid::Document

  field :name
  key :name
  #item: "<type> <id>"
  field :items, :type => Array, :default => []
  field :primary, :type => Boolean, :default => false
  #cached fields
  field :items_count, :type => Integer, :default => 0
  field :desires_count, :type => Integer, :default => 0


  before_save :sync_count

  #relationships
  embeds_many :feeds

  #validations
  validates_length_of :name, :maximum => 20

  def sync_count
    self.items_count = self.items.size
    self.desires_count = self.items.select{|item| item.split(' ').first == "Desire"}.size
  end

end