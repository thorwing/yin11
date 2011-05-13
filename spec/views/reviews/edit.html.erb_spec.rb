require 'spec_helper'

describe "reviews/edit.html.erb" do
  before(:each) do
    @review = assign(:review, stub_model(Review,
      :title => "MyString",
      :content => "MyString"
    ))
  end

  it "renders the edit review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path(@review), :method => "post" do
      assert_select "input#review_title", :name => "review[title]"
      assert_select "input#review_content", :name => "review[content]"
    end
  end
end
