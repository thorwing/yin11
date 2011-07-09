# encoding: utf-8
require "foods_generator"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  Factory(:normal_user)
  Factory(:tester)
  Factory(:editor)
  Factory(:admin)

#  FoodsGenerator::generate_foods

  File.open(File.join(RAILS_ROOT, 'app/assets/provinces.txt')).each_line { |p|
    code, name, short_name, main_city_id, type = p.split(" ")
    Province.create( :code => code, :name => name, :short_name => short_name, :main_city_id => main_city_id, :type => type)
  }

  File.open(File.join(RAILS_ROOT, 'app/assets/cities.txt')).each_line { |c|
    code, province_code, name, postcode = c.split(" ")
    province = Province.first(:conditions => {:code => province_code } )
    city = province.cities.build(:code => code, :name => name, :postcode => postcode)
    city.save
  }

  roots = YAML.load(File.open("#{Rails.root.to_s}/app/assets/districts.yml"))
  roots.each do |city_name, districts|
    city = City.first(conditions: {name: city_name})
    districts.each {|d| city.districts.create(:name => d)} if city
  end

#  File.open(File.join(RAILS_ROOT, 'app/assets/city_ip.txt')).each_line { |c|
#    start_ip, end_ip, province_name, city_name = c.split(" ")
#    CityIp.create(:start_ip => start_ip, :end_ip => end_ip, :province_name => province_name, :city_name => city_name)
#  }

#watermelon = Food.first(conditions: {name: "西瓜"})
  #orange = Food.first(conditions: {name: "橙子"})
  #milk = Food.first(conditions: {name: "牛奶"})

  #shanghai = Factory(:city, :code => "021", :name => "上海", :postcode => "20000" )
  #beijing = Factory(:city, :code => "010", :name => "北京", :postcode => "10000" )
  #article_1 = Factory(:article, :title => "三聚氰胺再现上海", :content => "三聚氰胺又再次出现在了上海，市民们很担心。", :cities => [shanghai], :foods => [milk], :category => "case")
  #article_2 = Factory(:article, :title => "北京禁止商贩往水里兑牛奶", :content => "北京市政府严令禁止向水里兑牛奶的行为。", :cities => [beijing], :foods => [milk], :category => "case")
  #article_3 = Factory(:article, :title => "上海橙子上蜡", :content => "近日，上海市的水果市场上出现了上了蜡的橙子。", :cities => [shanghai], :foods => [orange], :category => "case")

  #Factory(:badge, :name => "新手上路", :description => "发表一篇测评", :contribution_field => "posted_reviews", :comparator => 8, :compared_value => "1" )


