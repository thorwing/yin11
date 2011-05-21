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
  FoodsGenerator::generate_foods

  watermelon = Food.first(conditions: {name: "西瓜"})
  orange = Food.first(conditions: {name: "橙子"})
  milk = Food.first(conditions: {name: "牛奶"})

  shanghai = Factory(:city, :code => "021", :name => "上海", :post_code => "20000" )
  beijing = Factory(:city, :code => "010", :name => "北京", :post_code => "10000" )
  article_1 = Factory(:article, :title => "三聚氰胺再现上海", :cities => [shanghai], :foods => [milk])
  article_2 = Factory(:article, :title => "北京禁止商贩往水里兑牛奶", :cities => [beijing], :foods => [milk])

  vendor = Vendor.create(:name => "乐购超市")

  category_1 =  Factory(:wiki_category, :name => "食物")
  milk_page = WikiPage.create(:title => milk.name, :content => '<h2 class="wiki_sec_h" id="conflict_sec">食物相克</h2><ul><li>橙子: 影响维生素吸收</li></ul><h2 class="wiki_sec_h">其它</h2><p>&nbsp;&nbsp;&nbsp;&nbsp; 测试文本</p>')
end


Given /^There is a sample tip$/ do
  tip = Tip.new(:title => "西瓜判熟技巧")
  tip.type = 2
  tip.current_content = "一看，二拍，三听"
  tip.revisions << Revision.new(:content => "一看，二拍，三听")
  tip.tags << Tag.new(:title => "西瓜") << Tag.new(:title => "处理技巧")
  tip.save
end