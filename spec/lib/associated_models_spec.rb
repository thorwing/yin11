require "spec_helper"

describe "AssociatedModels" do
  class AssociatedModelsSample
    include Mongoid::Document
    include AssociatedModels
    associate_models :vendor
    has_many :reviews
    tokenize_many :reviews
    has_one :user
    tokenize_one :user
  end

  it "it works" do
    AssociatedModelsSample.respond_to?(:tokenize_many).should == true
    AssociatedModelsSample.respond_to?(:tokenize_one).should == true
  end

  it "associate_models works" do
    e = AssociatedModelsSample.new
    e.respond_to?(:vendor_id).should == true
    e.respond_to?(:vendor).should == true
  end

  it "tokenize_many works" do
    e = AssociatedModelsSample.new
    e.respond_to?(:review_tokens).should == true
  end

   it "tokenize_one works" do
    e = AssociatedModelsSample.new
    e.respond_to?(:user_token).should == true
  end
end