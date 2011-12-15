require 'spec_helper'

describe Ingredient do

  it {should validate_presence_of :name}
  it {should validate_presence_of :amount}
  #it {should validate_presence_of :is_major_ingredient}
  it {should ensure_length_of(:name ).
    is_at_most(20) }
  it {should ensure_length_of(:amount ).
    is_at_most(10) }

end
