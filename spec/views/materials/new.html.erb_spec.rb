require 'spec_helper'

describe "materials/new.html.erb" do
  before(:each) do
    assign(:material, stub_model(Material,
      :name => "MyString",
      :amount => "MyText"
    ).as_new_record)
  end

  it "renders new material form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => materials_path, :method => "post" do
      assert_select "input#material_name", :name => "material[name]"
      assert_select "textarea#material_amount", :name => "material[amount]"
    end
  end
end
