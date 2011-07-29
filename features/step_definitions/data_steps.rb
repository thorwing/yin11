# encoding: utf-8

Given /^There are minimum seeds data$/ do
  @normal_user = Factory(:normal_user)
  @tester = Factory(:tester)
  @editor = Factory(:editor)
  @admin = Factory(:admin)

  Factory(:shanghai, :name => "上海", :postcode => "20000")
end

Given /^There are some sample articles$/ do
  Article.create(:title => "三聚氰胺再现上海", :content => "三聚氰胺又再次出现在了上海，市民们很担心。", :region_tokens => "021", :tags_string => "牛奶, 三聚氰胺")
  Article.create(:title => "北京禁止商贩往水里兑牛奶", :content => "北京市政府严令禁止向水里兑牛奶的行为。", :tags_string => "牛奶")
end

Given /^There are some sample groups$/ do
  group = Group.new(:name => "西瓜守望者", :tags_string => "西瓜")
  group.creator_id = @editor.id
  group.save!
end

Given /^There are some sample reviews$/ do
  Factory(:bad_review, :title => "牛奶坏了", :tags_string => "牛奶")
end


Given /^There is a simple tip$/ do
  tip = Tip.new(:title => "西瓜判熟技巧")
  tip.content = "一看，二拍，三听，四，试吃"
  tip.revisions << Revision.new(:content => "一看，二拍，三听")
  #tip.tags << Tag.new(:title => "西瓜") << Tag.new(:title => "处理技巧")
  tip.save
end

Given /^There are some sample tips$/ do
  roots = YAML.load(File.open("#{Rails.root.to_s}/app/assets/tips.yml"))
  roots.each do |tip|
    Tip.create!(:title => tip["title"], :content => tip["content"], :tags_string => tip["tags_string"])
  end
end
