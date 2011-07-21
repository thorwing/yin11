require "spec_helper"

describe "AssociatedModels" do
  class Sample
    include Mongoid::Document
    include AssociatedModels
    associate_models :vendor
    has_many :reviews
    tokenize_many :reviews
    has_one :user
    tokenize_one :user
  end

  it "it works" do
    Sample.respond_to?(:tokenize_many).should == true
    Sample.respond_to?(:tokenize_one).should == true
  end

  it "associate_models works" do
    e = Sample.new
    e.respond_to?(:vendor_id).should == true
    e.respond_to?(:vendor).should == true
  end

  it "tokenize_many works" do
    e = Sample.new
    e.respond_to?(:review_tokens).should == true
  end

   it "tokenize_one works" do
    e = Sample.new
    e.respond_to?(:user_token).should == true
  end
end