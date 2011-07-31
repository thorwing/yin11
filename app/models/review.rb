class Review < InfoItem
  field :faults, :type => Array, :default => []

  attr_accessible :faults

  #relationships
  belongs_to :vendor
  tokenize_one :vendor

  #override the settings in Informative
  validates_length_of :content, :maximum => 3000

  before_validation {
    self.positive = false unless self.faults.empty?
    if (self.vendor)
      self.city = self.vendor.city
      self.street = self.vendor.street
    end
    true
  }

  def get_faults
    self.faults.empty? ? I18n.t("general.none") : self.faults.join("|")
  end

  #for gmaps4rails
  def gmaps4rails_infowindow
    "<h3>#{ERB::Util.html_escape self.title}</h3><a href=/reviews/#{self.id.to_s}>#{I18n.t("general.show")}</a>"
  end

  def gmaps4rails_sidebar
    "<span>#{ERB::Util.html_escape self.title}</span>"
  end

end
