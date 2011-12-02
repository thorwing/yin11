require 'spec_helper'

describe "materials/edit.html.erb" do
  before(:each) do
    @material = assign(:material, stub_model(Material,
      :name => "MyString",
      :amount => "MyText"
    ))
  end

  it "renders the edit material form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => materials_path(@material), :method => "post" do
      assert_select "input#material_name", :name => "material[name]"
      assert_select "textarea#material_amount", :name => "material[amount]"
    end
  end
end
