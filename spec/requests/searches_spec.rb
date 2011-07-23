require 'spec_helper'

describe "Searches" do

  before { @review = Review.create!(:title => "I bought some stink milk", :tags_string => "milk", :region_tokens => "021")}

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

end
