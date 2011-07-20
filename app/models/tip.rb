class Tip < InfoItem
  include Mongoid::Document

  field :current_version_id, :type => String

  #relationships
  embeds_many :revisions
  has_and_belongs_to_many :writers, :class_name => "User"
  belongs_to :user, :inverse_of => "collected_tips"

  #override the settings in Informative
  validates_uniqueness_of :title, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))
  validates_length_of :title, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.content"),
                                                                        :max => 20)
  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :minimum => 10, :maximum => 200, :message => I18n.translate("validations.general.length_msg", :field => I18n.translate("general.content"),
                                                                        :min => 10, :max => 200)

  def revise(author)
    if author.present?
      revisions_size = self.new_record? ? 0 : self.revisions.size
      current_version = self.revisions.find(self.current_version_id) if revisions_size > 0
      if current_version and current_version.content == self.content and current_version.title == self.title
        #You have tried to save without changing its content
        false
      else
        self.author_id = author.id if self.author_id.blank?
        self.writers << author unless self.writer_ids.include?(author.id)
        new_version = Revision.new(:title => self.title, :content => self.content, :author_id => author.id)
        self.revisions << new_version
        self.current_version_id = new_version.id
        true
      end
    else
      false
    end
  end

  def roll_back!(revision_id)
    old_version = self.revisions.find(revision_id)
    self.title = old_version.title
    self.content = old_version.content
    self.current_version_id = old_version.id
    self.save!
  end

end
