# encoding: utf-8

#TODO
def generate_user_info (name)
  case name
      when "David User"
        email = "david@yin11.com"
        password = "iamdavid"
        login_name = "David"
        role = 1
      when "Kate Tester"
        email = "kate@yin11.com"
        password = "iamkate"
        login_name = "Kate"
        role = 1
      when "Castle Editor"
        email = "editor@yin11.com"
        password = "iameditor"
        login_name = "Castle"
        role = 2
      when "Ray Admin"
        email = "admin@yin11.com"
        password = "superuser"
        login_name = "Ray"
        role = 9
      else
        assert false
  end

  return email, password, login_name, role
end

Given /^There is a "(.+)"$/ do |name|
  email, password, login_name, role = generate_user_info(name)

  Factory(:user, :email => email, :login_name => login_name, :password => password, :role => role)
end

Given /^There are minimal testing records$/ do
  shanghai = Factory(:city, :code => "021", :name => "上海", :postcode => "20000" )
  beijing = Factory(:city, :code => "010", :name => "北京", :postcode => "10000" )
  article_1 = Article.create(:title => "三聚氰胺再现上海", :content => "三聚氰胺又再次出现在了上海，市民们很担心。",  :region_ids => [shanghai.id], :tags_string= => ["牛奶"])
  article_2 = Article.create(:title => "北京禁止商贩往水里兑牛奶", :content => "北京市政府严令禁止向水里兑牛奶的行为。", :region_ids => [beijing.id], :tags_string= => ["牛奶"])

  vendor = Vendor.create(:name => "乐购超市")

end


Given /^There is a sample tip$/ do
  tip = Tip.new(:title => "西瓜判熟技巧")
  tip.type = 2
  tip.content = "一看，二拍，三听，四，试吃"
  tip.revisions << Revision.new(:content => "一看，二拍，三听")
  #tip.tags << Tag.new(:title => "西瓜") << Tag.new(:title => "处理技巧")
  tip.save
end