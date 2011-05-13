require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the WikiHelper. For example:
#
# describe WikiHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe FoodsHelper do
  describe "use regrex to detect conflicts bettween foods" do
    it "can get conflicts between two foods" do
      milk = Factory(:food, :name => "Milk")
      orange = Factory(:food, :name => "Orange")
      milk_page = WikiPage.create(:title => milk.name, :content => '<h2 class="wiki_sec_h" id="conflict_sec">Conflict</h2><ul><li>Orange: blah</li></ul><h2 class="wiki_sec_h">Dummy</h2><p>&nbsp;&nbsp;&nbsp;&nbsp; dummy text</p>')

      foods = [milk, orange]

      helper.get_conflicts_of(foods).to_s.should == '[{:food1=>"Milk", :food2=>"Orange", :detail=>"blah"}]'
     end
   end


end