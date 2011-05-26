class Tip
  include Mongoid::Document
  include Informative

  field :type, :type => Integer, :default => 0

  #relationships
  embeds_many :revisions
  #embeds_one :current_vision, :class_name => "Revision"
  has_and_belongs_to_many :participators, :class_name => "User"
  has_and_belongs_to_many :tags

  validates_uniqueness_of :title, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))
  validates_inclusion_of :type, :in => 1..2

  HANDLE_TIP = 1
  EXAM_TIP =  2

  def revise(author)
    if author.present?
#      revisions_size = self.new_record? ? 0 : self.revisions.size
#      if (revisions_size > 0) and self.content == content
#        #'You have tried to save page "#{name}" without changing its content'
#      end

      self.participators << author unless self.participator_ids.include?(author.id)

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
