require 'spec_helper'

describe Source do
  it {should validate_presence_of :name}
  it {should ensure_length_of(:name ).
    is_at_most(20) }
  it {should ensure_length_of(:site ).
    is_at_most(20) }

  #it {should validate_format_of :url)
  #   with('12345').
  #    #                 with_message(/is not optional/) }
  #}

  #it { should validate_format_of(:url).
  #           not_with('12D45').
  #           with_message("kmlkmkl")
  #}
  #
  #it { should validate_format_of(:url).
  #           with('http:').
  #           with_message("not valid")
  #}

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

  it "empty url is ok" do
    Source.new(:name => "Yin11News", :site => "somesite").should be_valid
  end

  it "false url won't be accepted'" do
    source = Source.new(:name => "Yin11News")
    source.url = "invalid.com"
    source.valid?.should == false
  end
end