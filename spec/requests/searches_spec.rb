require 'spec_helper'

describe "Search" do

  before { @review = Factory(:bad_review, :tags_string => "milk", :city => "Shanghai")}

  describe "search by tags" do
    before { Rails.cache.clear }

    it "should contain" do
      search_for(@review.tags_string)
      within("#items_list") do
        page.should have_content(@review.title)
      end
    end
  end

  describe "search by title" do
    it "should contain" do
      #try to avoid searching by tags
      search_for(@review.title)
      within("#items_list") do
        page.should have_content(@review.title)
      end
    end
  end

  describe "search by location" do
    it "should contain" do
      search_for("Shanghai")
      within("#items_list") do
        page.should have_content(@review.title)
      end
    end
  end

  context "There is another review with same tag" do
    before { @beijing = Factory(:beijing) }
    before { @another_review = Factory(:bad_review, :title => "The beverage tastes funny", :tags_string => @review.tags_string, :city => @beijing.name)}

    describe "track by tag" do
      it "should contain" do
        visit root_path
        page.should have_content (@another_review.tags_string)
        within(".item") do
          click_link @another_review.tags_string
        end
        page.should have_content @another_review.title
        page.should have_content @review.title
      end
    end

    describe "track by location" do
      it "should contain" do
        visit root_path
        search_for(@beijing.name)
        page.should have_content @another_review.title
        page.should_not have_content @review.title
      end
    end

  end

end
