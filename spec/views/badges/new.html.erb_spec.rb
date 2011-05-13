require 'spec_helper'

describe "badges/new.html.erb" do
  before(:each) do
    assign(:badge, stub_model(Badge,
      :name => "MyString",
      :description => "MyString",
      :repeatable => false
    ).as_new_record)
  end

  it "renders new badge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => badges_path, :method => "post" do
      assert_select "input#badge_name", :name => "badge[name]"
      assert_select "input#badge_description", :name => "badge[description]"
      assert_select "input#badge_repeatable", :name => "badge[repeatable]"
    end
  end
end
