require 'spec_helper'

describe "bvt" do
  it "simpley create a article" do
    article = Factory.create(:article, :title => "test", :content => "1234567890")
    article.should_not be_new_record
    article.should_not be_nil
  end

  it "title can't be nil" do
    article = Factory.build(:article, :content => "1234567890")
    article.valid?.should equal false
  end

  it "content can't be nil" do
    article = Factory.build(:article, :title => "test")
    article.valid?.should equal false
  end
end

describe "boundary" do
  it "title's max length is 20" do
    article = Factory.create(:article, :title => "test", :content => "1234567890")
    article.title = "123456789012345678901"
    article.valid?.should equal false
  end

  it "content's min length is 10" do
    article = Factory.create(:article, :title => "test", :content => "1234567890")
    article.content = "123"
    article.valid?.should equal false
  end

  it "source's min length is 20" do
    article = Factory.create(:article, :title => "test", :content => "1234567890")
    article.source = "123456789012345678901"
    article.valid?.should equal false
  end
end