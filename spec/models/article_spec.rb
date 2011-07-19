require 'spec_helper'

describe "Article" do
  it "simpley create a article" do
    article = Article.create(:title => "test", :content => "1234567890")
    article.should_not be_new_record
    article.should_not be_nil
  end

  it "title can't be nil" do
    article = Article.new(:content => "1234567890")
    article.valid?.should == false
  end

  it "content can't be nil" do
    article = Article.new(:title => "test")
    article.valid?.should == false
  end

  it "title's max length is 30" do
    article = Article.new(:title => "test", :content => "1234567890")
    article.title = "1" * 31
    article.valid?.should == false
  end

  it "content's max length is 10000" do
    article = Article.new(:title => "test", :content => "1234567890")
    article.title = "1" * 10001
    article.valid?.should == false
  end

end