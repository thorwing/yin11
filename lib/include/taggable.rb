module Taggable
  def self.included(base)
    base.class_eval do
      field :name
      key :name

      #relationships
      has_and_belongs_to_many :info_items

      attr_accessible :name

      validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name") )
      validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))
      validates_length_of :name, :maximum => 10, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.name"),
                                                                             :max => 10)
    end
  end
end
