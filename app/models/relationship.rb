class Relationship
  include Mongoid::Document

  field :target_type, :type => String
  field :target_id, :type => String

  attr_accessible :target_type, :target_id

  #relationships
  embedded_in :user

  def get_item
    eval("#{target_type}.find(\"#{target_id}\")")
  end

end