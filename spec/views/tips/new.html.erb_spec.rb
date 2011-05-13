require 'spec_helper'

describe "tips/new.html.erb" do
  before(:each) do
    assign(:tip, stub_model(Tip,
      :title => "MyString",
      :content => "MyString"
    ).as_new_record)
  end

  it "renders new tip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tips_path, :method => "post" do
      assert_select "input#tip_title", :name => "tip[title]"
      assert_select "input#tip_content", :name => "tip[content]"
    end
  end
end
