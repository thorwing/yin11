#incoding utf-8
require 'spec_helper'

describe Article do

  it {should validate_presence_of :title}
  it {should validate_presence_of :content}
  it {should validate_presence_of :type}
  it {should ensure_length_of(:title ).
    is_at_most(30) }
  it {should ensure_length_of(:content ).
    is_at_most(10000) }
  it {should ensure_length_of(:introduction).
    is_at_most(300) }




  it "simpley create a article" do
    @editor = Factory(:editor)
    @editor.should be_valid
    Article.new(:title => "test", :content => "sample text", :type => I18n.t("article_types.news"), :author_id=> @editor.id).should be_valid
  end


  #it "title is mandatory" do
  #  Article.new(:content => "sample text").should_not be_valid
  #end
  #
  #it "content is mandatory" do
  #  Article.new(:title => "test").should_not be_valid
  #end

  #it "title's max length is 30" do
  #  Article.new(:title => "1" * 31, :content => "sample text").should_not be_valid
  #end
  #
  #it "content's max length is 10000" do
  #  Article.new(:title => "test", :content => "1" * 10001).should_not be_valid
  #end

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

  #it "of_region" do
  #  beijing = Factory(:beijing)
  #  item = Factory(:article, :region_tokens => beijing.id.to_s)
  #  Article.of_region(beijing.id).should include(item)
  #end

end