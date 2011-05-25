Feature: smoke tests for Articles
  Only Editor and Admin can create new articles.
  Only Editor and Admin can edit articles.
  Only Editor and Admin can disable articles.
  Editor can upload images for an article, and one of the images will be displayed as thumbnail.
  Editor can add descriptions on images.
  User can vote fro a article.
  User can comment on a article, comments can be nested.

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

  @focus
  Scenario: Editor can upload images for an article, and one of the images will be displayed as thumbnail.
    When I log in as "Castle Editor"
    And I go to the new_article page
    And I fill in "article_title" with "西瓜被打了催熟剂"
    And I fill in "article_content" with "本报讯，今日很多西瓜都被打了催熟剂"
    #And I follow "添加图片"
    #And I fill in "article_images_attributes_0_remote_image_url" with "http://rubyonrails.org/images/rails.png" by Selenium
    And I fill in "article_images_attributes_0_remote_image_url" with "http://rubyonrails.org/images/rails.png"
    And I fill in "article_images_attributes_0_description" with "Rails标志"
    And I press "发表"
    Then I should see "Images(1):"
    And I should see "Rails标志"

  Scenario: User can vote fro a article.
    Given the following article exists:
      | title            | content                            | food_tokens |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |

    When I log in as "David User"
    Then I should see "西瓜被打了催熟剂"
    When I follow "up" within ".info_item"
    Then I should see "1" within ".info_item"

  Scenario: User can comment on a article, comments can be nested.
    Given the following article exists:
      | title            | content                            | food_tokens |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |

    When I log in as "Kate Tester"
    Then I should see "西瓜被打了催熟剂"
    When I follow "查看" within ".info_item"
    And I fill in "content" with "很有用的评价" within ".new_comment"
    And I press "添加"
    And I go to the home page
    Then I should see "1 comments" within ".info_item"

    When I log in as "David User"
    When I follow "查看" within ".info_item"
    And I follow "Reply"
    And I fill in "content" with "谢谢" within ".new_comment"
    And I press "添加"
    And I go to the home page
    Then I should see "2 comments" within ".info_item"