require 'spec_helper'

describe "tips/index.html.erb" do
  before(:each) do
    assign(:tips, [
      stub_model(Tip,
        :title => "Title",
        :content => "Content"
      ),
      stub_model(Tip,
        :title => "Title",
        :content => "Content"
      )
    ])
  end

  it "renders a list of tips" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content".to_s, :count => 2
  end
end
