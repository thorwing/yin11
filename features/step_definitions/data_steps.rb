# encoding: utf-8

Given /^There are minimal testing records$/ do
  @normal_user = Factory(:normal_user)
  @tester = Factory(:tester)
  @editor = Factory(:editor)
  @admin = Factory(:admin)

  shanghai = City.create(:code => "021", :name => "上海", :postcode => "20000")
  beijing = City.create(:code => "010", :name => "北京", :postcode => "10000" )
  article_1 = Article.create(:title => "三聚氰胺再现上海", :content => "三聚氰胺又再次出现在了上海，市民们很担心。",  :region_ids => [shanghai.id], :tags_string= => ["牛奶"])
  article_2 = Article.create(:title => "北京禁止商贩往水里兑牛奶", :content => "北京市政府严令禁止向水里兑牛奶的行为。", :region_ids => [beijing.id], :tags_string= => ["牛奶"])

  vendor = Vendor.create(:name => "乐购超市")

end


Given /^There is a simple tip$/ do
  tip = Tip.new(:title => "西瓜判熟技巧")
  tip.content = "一看，二拍，三听，四，试吃"
  tip.revisions << Revision.new(:content => "一看，二拍，三听")
  #tip.tags << Tag.new(:title => "西瓜") << Tag.new(:title => "处理技巧")
  tip.save
end