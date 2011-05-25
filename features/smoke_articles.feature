Feature: smoke tests for Articles
  Only Editor and Admin can create new articles.
  Only Editor and Admin can edit articles.
  Only Editor and Admin can disable articles.
  Editor can upload images for an article, and one of the images will be displayed as thumbnail.
  Editor can add descriptions on images.
  User can vote fro a article.
  User can comment on a articel, comments can be nested.

  Background:
    Given There is a "David User"
    And There is a "Kate Tester"
    And There is a "Ray Admin"
    And There is a "Castle Editor"
    And There are minimal testing records

  Scenario: Only Editor and Admin can create new articles.
    When I log in as "David User"
    And I go to the articles page
    Then I should not see "发表新文章"

    When I log in as "Castle Editor"
    And I go to the articles page
    Then I should see "发表新文章"

    When I log in as "Ray Admin"
    And I go to the articles page
    Then I should see "发表新文章"

  Scenario: Only Editor and Admin can edit articles.
    When I log in as "Castle Editor"
    And I post a sample article
    And I go to the articles page
    And I follow "土豆刷绿漆，冒充西瓜"
    Then I should see "编辑"

    When I log in as "Ray Admin"
    And I go to the articles page
    And I follow "土豆刷绿漆，冒充西瓜"
    Then I should see "编辑"

    When I log in as "David User"
    And I go to the articles page
    And I follow "土豆刷绿漆，冒充西瓜"
    Then I should not see "编辑"

  Scenario: Only Editor and Admin can disable articles.
    Given the following article exists:
      | title            | content                            | food_tokens |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |
    When I search for "西瓜"
    Then I should see "西瓜被打了催熟剂" within "div.food_articles"

    When I log in as "Ray Admin"
    And I go to the articles page
    And I follow "西瓜被打了催熟剂"
    And I follow "编辑"
    And I follow "禁用"
    When I search for "西瓜"
    Then I should not see "西瓜被打了催熟剂" within "div.food_articles"

  Scenario: Editor can upload images for an article, and one of the images will be displayed as thumbnail.


  Scenario: Editor can add descriptions on images.

  Scenario: User can vote fro a article.
  Scenario: User can comment on a articel, comments can be nested.
