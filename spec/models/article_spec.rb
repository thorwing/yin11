require 'spec_helper'

describe Article do
  it "simpley create a article" do
    Article.new(:title => "test", :content => "sample text", :type => "news").should be_valid
  end

  it "title is mandatory" do
    Article.new(:content => "sample text").should_not be_valid
  end

  it "content is mandatory" do
    Article.new(:title => "test").should_not be_valid
  end

  it "title's max length is 30" do
    Article.new(:title => "1" * 31, :content => "sample text").should_not be_valid
  end

  it "content's max length is 10000" do
    Article.new(:title => "test", :content => "1" * 10001).should_not be_valid
  end

  it "type will be automatically set if empty" do
    article = Article.create(:title => "test", :content => "sample text")
    article.type.should == "news"
  end

  it "type must be of certain value" do
    Article.create(:title => "test", :content => "sample text", :type => "test").should_not be_valid
  end

  it "name_of_source is empty" do
    article = Article.new(:title => "test", :content => "sample text")
    article.name_of_source.should be_nil
  end

  it "name_of_source works" do
    article = Article.new(:title => "test", :content => "sample text")
    article.build_source(:name => "yin11 news")
    article.name_of_source.should == "yin11 news"
  end


end