require 'spec_helper'

describe "badges/index.html.erb" do
  before(:each) do
    assign(:badges, [
      stub_model(Badge,
        :name => "Name",
        :description => "Description",
        :repeatable => false
      ),
      stub_model(Badge,
        :name => "Name",
        :description => "Description",
        :repeatable => false
      )
    ])
  end

  it "renders a list of badges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
