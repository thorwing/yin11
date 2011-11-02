Feature: articles

  Background:
    Given There are minimum seeds data



  Scenario: Editor can choose a type for the article
    When I log in as "Castle Editor"
    And I follow "+文章"
#    Then "news" should be selected for "article_type"
    And I select "新闻" from "article_type"
    And I select "锦囊" from "article_type"
    And I select "专题" from "article_type"

  Scenario: The default source of an article is Yin11
    When I log in as "Castle Editor"
    And I follow "+文章"
    Then the "article_source_attributes_name" field should contain "银筷子原创"

  Scenario: Editor can post an article and that article will be rendered to others
    When I log in as "Castle Editor"
    And I post a simple article

    When I log out
    And I go to the home page
    Then I should see "土豆刷绿漆，冒充西瓜"

  Scenario: Editor can create a topic which should be displayed on the home page
    When I log in as "Castle Editor"
    And I follow "+文章"
    And I fill in "article_title" with "食物相克不科学"
    And I fill in "article_content" with "这是不科学的说法"
    And I select "专题" from "article_type"
    And I press "完成"
    When I go to the articles page
    Then I should see "食物相克不科学"


  Scenario: Recommended articles will be displayed seperately
    When I log in as "Mighty Admin"
    And I go to the administrator_articles page
    Then I should see "推荐文章"

  @javascript
  Scenario: User can vote for a article.
    Given the following article exists:
      | title            | content                            | tags_string |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |

    When I log in as "David User"
    And I go to the articles page
    Then I should see "西瓜被打了催熟剂"
    When I follow "up" within ".vote_fields"
    Then I should see "1" within ".vote_fields"


