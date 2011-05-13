class Checkpoint
  include Mongoid::Document
  include AssociatedModels
  field :pass, :type => Boolean, :default => true
  field :title

  #Relationships
  embedded_in :review

  def display_title
    text = self.title
    text = self.tip.to_a(&:title).join(" ") if text.blank?

    text
  end
end
