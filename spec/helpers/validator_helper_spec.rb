require 'spec_helper'

class Sample
  include Mongoid::Document
  field :primary
  field :secondary
  field :content_with_max
  field :content_with_min
  field :content_with_max_and_min

  validates_presence_of :primary
  validates_length_of :content_with_max, :maximum => 99
  validates_length_of :content_with_min, :minimum => 10
  validates_length_of :content_with_max_and_min, :maximum => 99, :minimum => 10
end

I18n.locale = "zh-CN"

describe ValidatorHelper do
  it "mark the required fields with *" do
    helper.mark_required(Sample, :primary).should == "*"
    helper.mark_required(Sample.new, :primary).should == "*"
  end

  it "mark the required fields with *" do
    helper.mark_required(Sample, :secondary).should be_nil
    helper.mark_required(Sample.new, :secondary).should be_nil
  end

  it "mark_required_length max" do
    helper.mark_required_length(Sample, :content_with_max).should include("99")
    helper.mark_required_length(Sample.new, :content_with_max).should include("99")
  end

  it "mark_required_length min" do
    helper.mark_required_length(Sample, :content_with_min).should include("10")
    helper.mark_required_length(Sample.new, :content_with_min).should include("10")
  end

  it "mark_required_length min and max" do
    helper.mark_required_length(Sample, :content_with_max_and_min).should include("10")
    helper.mark_required_length(Sample, :content_with_max_and_min).should include("10")

    helper.mark_required_length(Sample.new, :content_with_max_and_min).should include("99")
    helper.mark_required_length(Sample.new, :content_with_max_and_min).should include("99")
  end

end
