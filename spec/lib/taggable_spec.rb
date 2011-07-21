require "spec_helper"

describe "Taggable" do
  class Sample
    include Mongoid::Document
    include Taggable
  end

  it "it works" do
    e = Sample.new
    e.respond_to?(:tags).should == true
    e.respond_to?(:tags_string).should == true
  end

  it "tags works" do
    Sample.create(:tags_string => "a, b, c")
    Sample.tags.should ==(["a","b","c"])
  end

  it "tags works" do
    Sample.create(:tags_string => "a, b")
    Sample.create(:tags_string => "c")
    Sample.tags.should == ["a","b","c"]
  end

  it "tags_with_weight works" do
    Sample.create(:tags_string => "a, b")
    Sample.create(:tags_string => "a")
    Sample.tags_with_weight.should ==([["a", 2], ["b",1]])
  end

  it "tagged_like works" do
    Sample.create(:tags_string => "milk, dog")
    Sample.create(:tags_string => "happy")
    Sample.tagged_like("do").should include("dog")
  end

it "tagged_like_regex works" do
    Sample.create(:tags_string => "milk, dog")
    Sample.create(:tags_string => "happy")
    Sample.tagged_like_regex(/do./).should include("dog")
  end

  it "tagged_with works" do
    e1 = Sample.create(:tags_string => "milk, dog")
    e2 = Sample.create(:tags_string => "happy")
    result = Sample.tagged_with("dog")
    result.should include(e1)
    result.should_not include(e2)
  end

   it "tagged_with_any works" do
    e1 = Sample.create(:tags_string => "milk, dog")
    e2 = Sample.create(:tags_string => "happy")
    result = Sample.tagged_with_any(["dog", "tiger"])
    result.should include(e1)
    result.should_not include(e2)
  end


end