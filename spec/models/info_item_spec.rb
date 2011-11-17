require "spec_helper"

describe InfoItem do
  #it "it works" do
  #  InfoItem.new(:title => "test").should be_valid
  #end
  #
  #it "title is mandatory" do
  #  InfoItem.new.should_not be_valid
  #end
  #
  #it "max length of title is 30" do
  #  InfoItem.new(:title => "1 * 31").should be_valid
  #end
  #
  #it "reported_on is not accessible" do
  #  item = InfoItem.new(:title => "test", :reported_on => DateTime.now)
  #  item.reported_on.should be_nil
  #end
  #
  #it "reported_on_string works" do
  #  item = InfoItem.new(:title => "test")
  #  item.reported_on_string.should_not be_nil
  #  t = DateTime.now
  #  item.reported_on_string = t
  #  item.reported_on_string.should == t.strftime('%m/%d/%Y')
  #end
  #
  #it "is_recent works" do
  #  item = InfoItem.create(:title => "test")
  #  item.is_recent?.should == true
  #end
  #
  #it "is_popular works" do
  #  item = InfoItem.create(:title => "test")
  #  item.is_popular?.should == false
  #end
  #
  #it "not accept empty image" do
  #  item = InfoItem.new(:title => "test", :images => [Image.new])
  #  item.images.size.should == 0
  #end
  #
  #describe "positive" do
  #  before { @negative_review = Factory(:review, :faults => [FaultTypes.get_values.first])
  #           @positive_review = Factory(:review)
  #           @raw_article = Factory(:article)
  #           @tip_article = Factory(:article, :type => I18n.t("article_types.tip"))
  #           @news_article = Factory(:article, :type => I18n.t("article_types.news"))
  #           @tip = Factory(:tip) }
  #    it "should be correct" do
  #      @positive_review.positive = true
  #      @negative_review.positive = false
  #      @raw_article.positive = false
  #      @tip_article.positive = true
  #      @news_article.positive = false
  #      @tip.positive = true
  #    end
  #end
  #
  #describe "Scopes" do
  #  it "in_days_of works" do
  #    item = InfoItem.create(:title => "test")
  #    InfoItem.in_days_of(1).should include(item)
  #  end
  #
  #  it "about works" do
  #    item = InfoItem.create(:title => "test", :tags_string => "milk")
  #    InfoItem.about("milk").should include(item)
  #  end
  #
  #  it "of_types works" do
  #    item = Review.create(:title => "test")
  #    InfoItem.of_types([Review.name]).should include(item)
  #  end
  #
  #  it "bad works" do
  #    item = Review.create(:title => "test", :faults => [FaultTypes.get_values.first])
  #    InfoItem.bad.should include(item)
  #  end
  #
  #  #it "not_from_blocked_users works" do
  #  #  user = Factory(:normal_user)
  #  #  item = Tip.create(:title => "test")
  #  #  item.author_id = user.id
  #  #  item.save
  #  #
  #  #  InfoItem.not_from_blocked_users([user.id]).should_not include(item)
  #  #  lambda {
  #  #     InfoItem.not_from_blocked_users([])
  #  #  }.should raise_exception()
  #  #end
  #end

end