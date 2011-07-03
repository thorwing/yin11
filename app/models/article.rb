class Article < InfoItem
  field :category, :default => ArticleTypes.get_values.first

  #Relationships
  embeds_one :source

  accepts_nested_attributes_for :source, :reject_if => lambda { |s| s[:name].blank? }, :allow_destroy => true
  attr_accessible :category, :source_attributes

  validates_associated :source

  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :minimum => 10, :maximum => 10000, :message => I18n.translate("validations.general.length_msg", :field => I18n.translate("general.content"),
                                                                        :min => 10, :max => 10000)
  validates_inclusion_of :category, :in => ArticleTypes.get_values

  def name_of_source
    if self.source
      self.source.name.present? ? self.source.name : self.source.site
    else
      ""
    end
  end
end
