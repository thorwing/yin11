Feature: articles

  Background:
    Given There are minimum seeds data

  Scenario: Editor can enter new_article page via home page
    When I log in as "Castle Editor"
    Then I should see "+文章"
    When I follow "+文章"
    Then I should be on the new_admin_article page

    When I log in as "David User"
    Then I should not see "+文章"

  Scenario: Editor can choose a type for the article
    When I log in as "Castle Editor"
    And I follow "+文章"
#    Then "news" should be selected for "article_type"
    And I select "tip" from "article_type"
    And I select "topic" from "article_type"

  Scenario: The default source of an article is Yin11
    When I log in as "Castle Editor"
    And I follow "+文章"
    Then the "article_source_attributes_name" field should contain "银筷子原创"

  Scenario: Editor can create a topic which should be displayed on the home page
    When I log in as "Castle Editor"
    And I follow "+文章"
    And I fill in "article_title" with "食物相克不科学"
    And I fill in "article_content" with "这是不科学的说法"
    And I select "topic" from "article_type"
    And I press "完成"
    When I go to the home page
    Then I should see "食物相克不科学"