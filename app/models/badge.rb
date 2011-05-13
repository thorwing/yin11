class Badge
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :repeatable, :type => Boolean
end
