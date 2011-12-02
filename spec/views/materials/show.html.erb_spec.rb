require 'spec_helper'

describe "materials/show.html.erb" do
  before(:each) do
    @material = assign(:material, stub_model(Material,
      :name => "Name",
      :amount => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
