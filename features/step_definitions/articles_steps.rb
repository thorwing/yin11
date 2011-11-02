# encoding: utf-8

Given /^There are some sample articles$/ do
  Article.create(:title => "三聚氰胺再现上海", :content => "三聚氰胺又再次出现在了上海，市民们很担心。", :region_tokens => "021", :tags_string => "牛奶, 三聚氰胺")
  Article.create(:title => "北京禁止商贩往水里兑牛奶", :content => "北京市政府严令禁止向水里兑牛奶的行为。", :tags_string => "牛奶")
end

When /^I post a article with:$/ do |table|
  table.hashes.each do |hash|
    When %(I go to the new_article page)
    And %(I follow "+文章")
    And %(I fill in "article_title" with "#{hash["title"]}")
    And %(I fill in "article_content" with "#{hash["content"]}")
    And %(I fill in "article_tags_string" with "#{hash["tags"]}")
    And %(I press "完成")
  end
end
