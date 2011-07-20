require 'spec_helper'

describe District do
  let(:beijing) { Factory(:beijing) }

  it "it works" do
    District.new(:city_id => beijing.id, :name => "chaoyangqu").should be_valid
  end

  it "city is mandatory" do
    District.new(:city_id => beijing.id).should_not be_valid
  end

  it "name is mandatory" do
    District.new(:city_id => beijing.id).should_not be_valid
  end

end