# encoding: utf-8

Given /^There are minimum seeds data$/ do
  @normal_user = Factory(:normal_user)
  @tester = Factory(:tester)
  @editor = Factory(:editor)
  @admin = Factory(:administrator)

  sh_province = Factory(:province, :name => "上海", :code => "SH")
  Factory(:shanghai, :name => "上海", :postcode => "20000", :province_id => sh_province.id)
  bj_province = Factory(:province, :name => "北京", :code => "BJ")
  Factory(:beijing, :name => "北京", :postcode => "10000", :province_id => bj_province.id)
end

Given /^There are some groups$/ do
  groups = [{:name => "西瓜守望者", :tags => ["西瓜"]},
  {:name => "海鲜爱好者", :tags => ["海鲜", "龙虾"]},
  {:name => "肉食爱好者", :tags => ["肉类", "猪肉"]},
  {:name => "麻辣诱惑", :tags => ["川菜", "湘菜"]}]

  groups.each do |g|
    Group.create!(:name => g[:name]) do |group|
      group.tags = g[:tags]
      group.creator_id = @editor.id
    end
  end
end

Given /^There are some reviews$/ do

  Factory(:review, :content => "牛奶牛奶牛奶!", :author => @normal_user)
end


