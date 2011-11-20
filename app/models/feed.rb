class Feed
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :target_type
  field :target_id
  field :target_operation

  #relationships
  embedded_in :tag
  embedded_in :vendor
  embedded_in :user
  embedded_in :product
  embedded_in :group

  #validations
  def self.operations
    ["create", "update"]
  end

  validates_inclusion_of :target_operation, :in => Feed.operations

  def get_item
    begin
      eval("#{target_type}.find(\"#{target_id}\")")
    rescue
      nil
    end
  end

end