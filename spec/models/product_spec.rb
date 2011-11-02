require 'spec_helper'


describe Product do
  it {should validate_presence_of :name}
  it {should validate_presence_of :original_name}
  it {should ensure_length_of(:name).
    is_at_most(100) }

  before {
    @vendor = Factory(:valid_vendor)
    @product = Product.new(:name => "test", :vendor_id => @vendor.id)
    @product.original_name = "original_test"
  }
  subject{ @product }

  it {should be_valid}
end
