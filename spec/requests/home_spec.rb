require 'spec_helper'

describe "Home" do
  describe "home page" do
    it "welcome" do
      get root_path
      response.status.should be(200)
    end
  end

  describe "disabled items" do
    before(:each) do
      Review.delete_all
      Article.delete_all
      @reviews = (1..3).to_a.map { |i| Factory(:review, :title => "review_#{i.to_s}", :disabled => true) }
      @articles = (1..3).to_a.map { |i| Factory(:article, :title => "article_#{i.to_s}", :content => "sample text", :disabled => true) }
    end

    it "never get displayed" do
      visit root_path
      @reviews.each do |e|
        page.should_not have_content e.title
      end
      @articles.each do |e|
        page.should_not have_content e.title
      end
    end
  end

  describe "limited items are displayed on homepage" do
    let(:user) {Factory(:normal_user)}
    let(:tester) {Factory(:tester)}
    before(:all) do
      ITEMS_PER_PAGE_POPULAR = 3
      ITEMS_PER_PAGE_HOT = 3
      ITEMS_PER_PAGE_RECENT = 3
      ITEMS_PER_PAGE_GROUP = 3
    end

    before(:each) do
      Review.delete_all
      @reviews = (1..20).to_a.map { |i| Factory(:review, :title => "sample_#{i.to_s}") }
      middle = (@reviews.size / 2)
      @samples = @reviews[middle..middle + 2]
    end

    it "no magic" do
      visit root_path
      @samples.each do |e|
        page.should_not have_content e.title
      end
    end

    it "with higher votes get displayed" do
      @samples.each {|e| e.votes = 100; e.save! }
      visit root_path
      @samples.each do |e|
        page.should have_content e.title
      end
    end

    it "about hot topic get displayed" do
      @samples.each {|e| e.tags_string = "milk"; e.save! }
      visit root_path
      @samples.each do |e|
        page.should have_content e.title
      end
    end

    it "latest items get displayed" do
      @samples.each {|e| e.reported_on = DateTime.now; e.save! }
      visit root_path
      @samples.each do |e|
        page.should have_content e.title
      end
    end

    context "there is a group" do
      before(:each) do
        Group.delete_all
        @group = Group.new(:name => "milk team")
        @group.member_ids = [user.id, tester.id]
        @group.creator_id = tester.id
        @group.save!

        user.group_ids << @group.id
        user.save!
        tester.group_ids << @group.id
        tester.save

        @samples.each {|e| e.author_id = tester.id; e.save! }
      end

      it "group stuff get displayed" do
        login_as(user)
        @samples.each do |e|
          page.should have_content e.title
        end
      end
    end
  end

  describe "limited articles" do
    before(:all) do
      HOT_ARTICLES_ON_HOME_PAGE = 3
    end

    before(:each) do
      Article.delete_all
      @articles = (1..10).to_a.map { |i| Factory(:article, :title => "sample_#{i.to_s}", :content => "sample text") }
      middle = (@articles.size / 2)
      @samples = @articles[middle..middle + 2]
    end

    it "recommended articles get displayed" do
      @samples.each {|e| e.recommended = true; e.save! }
      visit root_path
      @samples.each do |e|
        page.should have_content e.title
      end
    end
  end

end
