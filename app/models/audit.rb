class Audit
  include Mongoid::Document
  include Mongoid::Timestamps
  #fields
  field :user_id
  field :user_ip
  field :product_url

  #validators
  validates_presence_of :user_id
  validates_presence_of :product_url
  validates_presence_of :user_ip

end