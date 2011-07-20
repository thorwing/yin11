require 'spec_helper'

describe Source do
  it "works with normal parameters" do
    source = Source.new do |s|
      s.name = "yin11news"
      s.site = "yin11news.com"
      s.url = "http://yin11.com"
    end

    source.valid?.should == true
  end

  it "works with mass assignment" do
    source = Source.new(:name => "yin11news", :site => "yin11news.com", :url => "http://yin11.com")
    source.valid?.should == true
    source.name.should == "yin11news"
    source.site.should == "yin11news.com"
    source.url.should == "http://yin11.com"
  end

  it "name is mandatory" do
    Source.new.should_not be_valid
  end

  it "name's max length is 20" do
    Source.new(:name => "1" * 21).should_not be_valid
  end

  it "site's max length is 20" do
    Source.new(:name => "Yin11News", :site => "1" * 21).should_not be_valid
  end

  it "empty url is ok" do
    Source.new(:name => "Yin11News", :site => "somesite").should be_valid
  end

  it "false url won't be accepted'" do
    source = Source.new(:name => "Yin11News")
    source.url = "invalid.com"
    source.valid?.should == false
  end
end