class Tip < InfoItem
  include Mongoid::Document

  #relationships
  embeds_many :revisions
  #embeds_one :current_vision, :class_name => "Revision"
  has_and_belongs_to_many :writers, :class_name => "User"
  belongs_to :user, :inverse_of => "collected_tips"

  #override the settings in Informative
  validates_uniqueness_of :title, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))
  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :minimum => 10, :maximum => 10000, :message => I18n.translate("validations.general.length_msg", :field => I18n.translate("general.content"),
                                                                        :min => 10, :max => 10000)

  def revise(author)
    if author.present?
#      revisions_size = self.new_record? ? 0 : self.revisions.size
#      if (revisions_size > 0) and self.content == content
#        #'You have tried to save page "#{name}" without changing its content'
#      end

      self.writers << author unless self.writer_ids.include?(author.id)

      self.revisions << Revision.new(:content => self.content, :author => author)
      true
    else
      false
    end
  end

  private

  def continuous_revision?(author)
    self.current_vision && (self.current_vision.author.id == author.id) && ( self.current_vision.updated_at > 30.minutes.ago)
  end

end
