Feature: admin articles

  Background:
    Given There are minimum seeds data

  Scenario: Only Editor and Admin can create new articles.
    When I log in as "David User"
    And I go to the articles page
    Then I should not see "+文章"
    And I go to the administrator_articles page
    Then I should not see "+文章"

    When I log in as "Castle Editor"
    And I go to the administrator_articles page
    Then I should see "+文章"

    When I log in as "Ray Admin"
    And I go to the administrator_articles page
    Then I should see "+文章"

  Scenario: Only Editor and Admin can edit articles.
    When I log in as "Castle Editor"
    And I post a simple article
    And I go to the articles page
    Then I should see "土豆刷绿漆，冒充西瓜"
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

  Scenario Outline: Editor and Admin can edit articles
    Given the following articles exists:
      | title            | content                            | tags_string | enabled |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜        | false    |

      When I go to the home page
      Then I should not see "西瓜被打了催熟剂"

      When I log in as "<user>"
      And I go to the administrator_articles page
      Then I follow "西瓜被打了催熟剂"
      And I follow "编辑"
      And I check "article_enabled"
      And I press "完成"

      And I go to the articles page
      Then I should see "西瓜被打了催熟剂"

    Examples:
    | user          |
    | Castle Editor |
    | Ray Admin     |

  Scenario: Admin can disable/enable articles by single click
    Given the following articles exists:
    | title      | content                | enabled |
    | 可疑的文章 | 这是一篇很可疑的文章   | false   |
    When I log in as "Ray Admin"
    When I go to the home page
    Then I should not see "可疑的文章"
    When I go to the administrator_articles page
    And I follow "toggle_link" within ".toggle.off"
    And I go to the articles page
    Then I should see "可疑的文章"


  Scenario: Admin can recommend/unrecommend articles by single click
    Given the following articles exists:
    | title      | content                | type | enabled |
    | 很棒的文章 | 这是一篇很棒的文章       | 新闻 | true   |
    When I log in as "Ray Admin"
    And I should not see "很棒的文章"
    When I go to the administrator_articles page
    And I follow "toggle_link" within ".toggle.off"
    And I go to the home page
    Then I should see "很棒的文章" within "#news_frame"


#  Scenario: Editor can upload images for an article, and one of the images will be displayed as thumbnail.
#    When I log in as "Castle Editor"
#    And I go to the new_article page
#    And I fill in "article_title" with "西瓜被打了催熟剂"
#    And I fill in "article_content" with "本报讯，今日很多西瓜都被打了催熟剂"
#    #And I follow "添加图片"
#    #And I fill in "article_images_attributes_0_remote_image_url" with "http://rubyonrails.org/images/rails.png" by Selenium
#    And I fill in "article_images_attributes_0_remote_image_url" with "http://rubyonrails.org/images/rails.png"
#    And I fill in "article_images_attributes_0_description" with "Rails标志"
#    And I press "发表"
#    Then I should see "图片(1):"
#    And I should see "Rails标志"





