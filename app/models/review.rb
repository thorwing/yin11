class Review < InfoItem
  field :faults, :type => Array, :default => []

  #relationships
  belongs_to :vendor
  tokenize_one :vendor

  attr_accessible :faults

  #override the settings in Informative
  validates_length_of :content, :maximum => 3000, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.content"),
                                                                           :max => 3000)

  #for gmaps4rails
  def gmaps4rails_infowindow
    "<h3>#{ERB::Util.html_escape self.title}</h3><a href=/reviews/#{self.id.to_s}>#{I18n.t("general.show")}</a>"
  end

  def gmaps4rails_sidebar
    "<span>#{ERB::Util.html_escape self.title}</span>"
  end

end
