class Feed
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :target_type
  field :target_id

  #relationships
  embedded_in :tag
  embedded_in :vendor
  embedded_in :user

  def get_item
    eval("#{target_type}.find(\"#{target_id}\")")
  end

end