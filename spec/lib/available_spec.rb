require "spec_helper"

describe "Available" do
  class AvailableSample
    include Mongoid::Document
    include Available
  end

  it "it works" do
    e = AvailableSample.new
    e.respond_to?(:enabled).should == true
    e.respond_to?(:recommended).should == true
  end

  it "enabled is true by default" do
    e = AvailableSample.new
    e.enabled.should == true
  end

  describe "Scope" do
    it "enabled works" do
      e1 = AvailableSample.new
      e1.enabled = false
      e1.save!
      e2 = AvailableSample.create!
      result = AvailableSample.enabled.all
      result.should_not include(e1)
      result.should include(e2)
    end

    it "enabled works" do
      e1 = AvailableSample.new
      e1.enabled = false
      e1.save!
      e2 = AvailableSample.create!
      result = AvailableSample.disabled.all
      result.should include(e1)
      result.should_not include(e2)
    end

  end


end