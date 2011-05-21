# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  FoodsGenerator::generate_foods

  Factory(:user, :email => "tester@test.de", :login_name => "Tester", :password => "iamtester", :role => 1 )
  Factory(:user, :email => "admin@test.de", :login_name => "Admin", :password => "superuser", :role => 9 )

  watermelon = Food.first(conditions: {name: "西瓜"})
  orange = Food.first(conditions: {name: "橙子"})
  milk = Food.first(conditions: {name: "牛奶"})

  shanghai = Factory(:city, :code => "021", :name => "上海", :post_code => "20000" )
  beijing = Factory(:city, :code => "010", :name => "北京", :post_code => "10000" )
  article_1 = Factory(:article, :title => "三聚氰胺再现上海", :cities => [shanghai], :foods => [milk])
  article_2 = Factory(:article, :title => "北京禁止商贩往水里兑牛奶", :cities => [beijing], :foods => [milk])
  article_3 = Factory(:article, :title => "上海橙子上蜡", :cities => [shanghai], :foods => [orange])

  Factory(:badge, :name => "新手上路", :description => "发表一篇测评", :user_field => "posted_reviews", :comparator => 8, :compared_value => "1" )

  File.open(File.join(RAILS_ROOT, 'app/assets/wiki_categories.txt')).each_line { |c|
    Factory(:wiki_category, :name => c)
  }

  File.open(File.join(RAILS_ROOT, 'app/assets/provinces.txt')).each_line { |p|
    code, name, short_name, main_city_id, type = p.split(" ")
    Factory(:province, :code => code, :name => name, :short_name => short_name, :main_city_id => main_city_id, :type => type)
  }

File.open(File.join(RAILS_ROOT, 'app/assets/cities.txt')).each_line { |c|
  code, province_code, name, post_code = c.split(" ")
  province = Province.first(:conditions => {:code => province_code } )
  city = province.cities.build(:code => code, :name => name, :post_code => post_code)
  city.save
}

#for test
#milk = Factory(:food, :name => "Milk")
#orange = Factory(:food, :name => "Orange")
#milk_page = WikiPage.create(:title => milk.name, :content => '<h2 class="wiki_sec_h" id="conflict_sec">Conflict</h2><ul><li>Orange: blah</li></ul><h2 class="wiki_sec_h">Dummy</h2><p>&nbsp;&nbsp;&nbsp;&nbsp; dummy text</p>')
#

