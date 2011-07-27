require "spec_helper"

describe "Taggable" do
  class TaggableSample
    include Mongoid::Document
    include Taggable
  end

  it "it works" do
    e = TaggableSample.new
    e.respond_to?(:tags).should == true
    e.respond_to?(:tags_string).should == true
  end

  describe "Scopes" do

    it "tags works" do
      TaggableSample.create(:tags_string => "a, b, c")
      TaggableSample.tags.should ==(["a","b","c"])
    end

    it "tags works" do
      TaggableSample.create(:tags_string => "a, b")
      TaggableSample.create(:tags_string => "c")
      TaggableSample.tags.should == ["a","b","c"]
    end

    it "tags_with_weight works" do
      TaggableSample.create(:tags_string => "a, b")
      TaggableSample.create(:tags_string => "a")
      TaggableSample.tags_with_weight.should ==([["a", 2], ["b",1]])
    end

    it "tagged_like works" do
      TaggableSample.create(:tags_string => "milk, dog")
      TaggableSample.create(:tags_string => "happy")
      TaggableSample.tagged_like("do").should include("dog")
    end

  it "tagged_like_regex works" do
      TaggableSample.create(:tags_string => "milk, dog")
      TaggableSample.create(:tags_string => "happy")
      TaggableSample.tagged_like_regex(/do./).should include("dog")
    end

    it "tagged_with works" do
      e1 = TaggableSample.create(:tags_string => "milk, dog")
      e2 = TaggableSample.create(:tags_string => "happy")
      result = TaggableSample.tagged_with("dog")
      result.should include(e1)
      result.should_not include(e2)
    end

     it "tagged_with_any works" do
      e1 = TaggableSample.create(:tags_string => "milk, dog")
      e2 = TaggableSample.create(:tags_string => "happy")
      result = TaggableSample.tagged_with(["dog", "tiger"])
      result.should include(e1)
      result.should_not include(e2)
     end
  end
end