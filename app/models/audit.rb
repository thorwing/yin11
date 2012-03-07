class Audit
  include Mongoid::Document
  include Mongoid::Timestamps
  #fields
  field :user_id
  field :user_ip
  field :url

end