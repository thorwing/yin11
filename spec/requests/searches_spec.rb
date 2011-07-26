require 'spec_helper'

describe "Search" do

  before { @review = Factory(:review, :tags_string => "milk", :faults => [FaultTypes.get_values.first])}

  describe "search by tags" do
    before { Rails.cache.clear }

    it "should contain" do
      search_for(@review.tags_string)
      within("#bad_items") do
        page.should have_content(@review.title)
      end
    end
  end

  describe "search by title" do
    it "should contain" do
      #try to avoid searching by tags
      search_for(@review.title)
      within("#bad_items") do
        page.should have_content(@review.title)
      end
    end
  end

  describe "search by location" do
    it "should contain" do
      search_for("Shanghai")
      within("#bad_items") do
        page.should have_content(@review.title)
      end
    end
  end

  context "There is another review with same tag" do
    before { @beijing = Factory(:beijing) }
    before { @another_review = Review.create!(:title => "The beverage tastes funny", :tags_string => @review.tags_string, :region_tokens => @beijing.id)}

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
        search_for(@review.tags_string)
        page.should have_content @beijing.name
        click_link @beijing.name
        page.should have_content @another_review.title
        page.should_not have_content @review.title
      end
    end

  end

end
