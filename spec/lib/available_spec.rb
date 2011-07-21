require "spec_helper"

describe "Available" do
  class Sample
    include Mongoid::Document
    include Available
  end

  it "it works" do
    e = Sample.new
    e.respond_to?(:disabled).should == true
    e.respond_to?(:recommended).should == true
  end

  it "disabled is false by default" do
    e = Sample.new
    e.disabled.should == false
  end

  describe "Scope" do
    it "enabled works" do
      e1 = Sample.new
      e1.disabled = true
      e1.save!
      e2 = Sample.create!
      result = Sample.enabled.all
      result.should_not include(e1)
      result.should include(e2)
    end

    it "disabled works" do
      e1 = Sample.new
      e1.disabled = true
      e1.save!
      e2 = Sample.create!
      result = Sample.disabled.all
      result.should include(e1)
      result.should_not include(e2)
    end

  end


end