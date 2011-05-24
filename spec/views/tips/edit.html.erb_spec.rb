require 'spec_helper'

describe "tips/edit.html.erb" do
  before(:each) do
    @tip = assign(:tip, stub_model(Tip,
      :title => "MyString",
      :content => "MyString"
    ))
  end

  it "renders the edit tip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tips_path(@tip), :method => "post" do
      assert_select "input#tip_title", :name => "tip[title]"
      assert_select "textarea#tip_content", :name => "tip[content]"
    end
  end
end
