class Report
  include Mongoid::Document

  field :content, :type => String

  #cached_values
  field :contact_email, :type => String

  #relationships
  belongs_to :vendor

  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :maximum => 500, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.content"),
                                                          :max => 500)
  attr_accessible :content, :contact_email

end