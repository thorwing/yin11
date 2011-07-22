require "spec_helper"

describe "Available" do
  class AvailableSample
    include Mongoid::Document
    include Available
  end

  it "it works" do
    e = AvailableSample.new
    e.respond_to?(:disabled).should == true
    e.respond_to?(:recommended).should == true
  end

  it "disabled is false by default" do
    e = AvailableSample.new
    e.disabled.should == false
  end

  describe "Scope" do
    it "enabled works" do
      e1 = AvailableSample.new
      e1.disabled = true
      e1.save!
      e2 = AvailableSample.create!
      result = AvailableSample.enabled.all
      result.should_not include(e1)
      result.should include(e2)
    end

    it "disabled works" do
      e1 = AvailableSample.new
      e1.disabled = true
      e1.save!
      e2 = AvailableSample.create!
      result = AvailableSample.disabled.all
      result.should include(e1)
      result.should_not include(e2)
    end

  end


end