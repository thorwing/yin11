require 'spec_helper'

describe "badges/edit.html.erb" do
  before(:each) do
    @badge = assign(:badge, stub_model(Badge,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit badge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => badges_path(@badge), :method => "post" do
      assert_select "input#badge_name", :name => "badge[name]"
      assert_select "input#badge_description", :name => "badge[description]"
    end
  end
end
