# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#Tester
Factory(:user, :email => "tester@test.de", :login_name => "Tester", :password => "iamtester", :role => 1 )
Factory(:user, :email => "admin@test.de", :login_name => "Admin", :password => "superuser", :role => 9 )

Factory(:food, :name => "西瓜")

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

