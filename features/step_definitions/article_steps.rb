# encoding: utf-8

Given /^There are some articles$/ do
  Article.create(:title => "关爱心脏：5种减少盐摄入量的方法", :content => "盐的摄入量过高会导致高血压......", :tags_string => "心脏", :author_id=> @normal_user.id, :type => "theme"  )  do |a|
      a.recommended = true
  end
  Article.create(:title => "三聚氰胺再现上海", :content => "三聚氰胺又再次出现在了上海，市民们很担心。", :region_tokens => "021", :tags_string => "牛奶, 三聚氰胺", :author_id=> @normal_user.id, :type => "news") do |a|
      a.recommended = true
  end
end

When /^I post an article with:$/ do |table|
  table.hashes.each do |hash|
    When %(I go to the new_article page)
    And %(I fill in "article_title" with "#{hash["title"]}")
    And %(I fill in "article_content" with "#{hash["content"]}")
    #And %(I fill in "article_tags_string" with "#{hash["tags"]}")
    And %(I select "#{hash["type"]}" from "article_type")
    And %(I press "完成")
  end
end

When /^I view an article named "(.+)"$/ do |name|
    When %(I go to the articles page)
    And %(I follow "#{name}")
end

When /^I disabled a article named "(.+)"$/ do |product_name|
  And %(I view an article named "#{product_name}")
  #And %(I view the details of article #{product_name})
  And %(I follow "编辑")
  And %(I uncheck "article_enabled")
  And %(I press "完成")
end

