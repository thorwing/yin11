module Informative
  def self.included(base)
    base.class_eval do
      field :title
      field :content

      field :votes, :type => Integer, :default => 0
      field :fan_ids, :type => Array, :default => []
      field :hater_ids, :type => Array, :default => []

      embeds_many :comments

      attr_accessible :title, :content

      validates_presence_of :title, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.title") )
      validates_length_of :title, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.title"),
                                                                         :max => 20)
      validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
      validates_length_of :content, :minimum => 10, :maximum => 2000, :message => I18n.translate("validations.general.length_msg", :field => I18n.translate("general.content"),
                                                                          :min => 20, :max => 2000)
    end
  end
end