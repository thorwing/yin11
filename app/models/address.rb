class Address
  include Mongoid::Document

  field :city
  field :street
  field :detail
  field :post_code

end