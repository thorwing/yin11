Feature: tests for general User module
  可以注册为新用户
  用户可以看到其他用户的基本信息

  Background:
    Given There are minimum seeds data

  Scenario: 可以注册为新用户
    When I go to the new_user page
    And I fill in "user_email" with "test_regiser@yin11.com"
    And I fill in "user_password" with "simplepassword"
    And I fill in "user_password_confirmation" with "simplepassword"
    And I press "注册"
    When I go to the login page
    And I fill in "email" with "test_regiser@yin11.com"
    And I fill in "password" with "simplepassword"
    And I press "登入"
    Then I should see "div" whose id is "control_panel"

  Scenario: 用户可以看到其他用户的基本信息
    Given There are some products
    When I log in as "David User"
    #later Kate will visit David via this review
    And I post a simple review for "梅山猪" with "发现了上好的猪肉"
    And I go to the me page
    And I follow "David" within "#user_panel"
    Then I should be on David's profile page
    And I should see "基本信息"
    And I should see "偏好设定"
    When I log out
    And I log in as "Kate Tester"
    And I go to the reviews page
    And I follow "David"
    Then I should be on David's user page
    And I should not see "基本信息"



  Scenario: User's name will be displayed in the item, and others can click the link to view his profile
    Given There are some products
    When I log in as "David User"
    And I post a simple review for "梅山猪" with "买到烂猪肉"
    When I log out
    And I log in as "Kate Tester"
    And I go to the reviews page
    Then I should see "买到烂猪肉"
    And I should see "David"
    When I follow "David"
    Then I should be on David's user page
    And I should see "David"
    And I follow "+关注"

  Scenario: Only Editor and Admin can create new articles.
    When I log in as "David User"
    And I go to the articles page
    Then I should not see "+文章"
    And I go to the administrator_articles page
    Then I should not see "+文章"

    When I log in as "Castle Editor"
    And I go to the administrator_articles page
    Then I should see "+文章"

    When I log in as "Mighty Admin"
    And I go to the administrator_articles page
    Then I should see "+文章"

  Scenario: Only Editor and Admin can edit articles.
    When I log in as "Castle Editor"
    And I post an article with:
    | title | content | tags |
    | 土豆刷绿漆，冒充西瓜  | 今日，A城警方在B超市，查获了一批疑似用土豆刷上油漆冒充的西瓜。 | 西瓜 |

    And I go to the articles page
    Then I should see "土豆刷绿漆，冒充西瓜"
    And I follow "土豆刷绿漆，冒充西瓜"
    Then I should see "编辑"

    When I log in as "Mighty Admin"
    And I go to the articles page
    And I follow "土豆刷绿漆，冒充西瓜"
    Then I should see "编辑"

    When I log in as "David User"
    And I go to the articles page
    And I follow "土豆刷绿漆，冒充西瓜"
    Then I should not see "编辑"

  Scenario Outline: Editor and Admin can edit articles
    Given the following articles exists:
      | title            | content                            | tags_string | enabled | type |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜        | false    | news |

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
    | Mighty Admin     |

  Scenario: Admin can disable/enable articles by single click
    Given the following articles exists:
    | title      | content                | enabled | type |
    | 可疑的文章 | 这是一篇很可疑的文章   | false   | news |
    When I log in as "Mighty Admin"
    When I go to the home page
    Then I should not see "可疑的文章"
    When I go to the administrator_articles page
    And I follow "toggle_link" within ".toggle.off"
    And I go to the articles page
    Then I should see "可疑的文章"


  Scenario: Admin can recommend/unrecommend articles by single click
    Given the following articles exists:
    | title      | content                | type | enabled |
    | 很棒的文章 | 这是一篇很棒的文章       | news | true   |
    When I log in as "Mighty Admin"
    And I should not see "很棒的文章"
    When I go to the administrator_articles page
    And I follow "toggle_link" within ".toggle.off"
    And I go to the articles page
    Then I should see "很棒的文章" within "#news_frame"


  #  Scenario: Editor can upload images for an article, and one of the images will be displayed as thumbnail.
  #    When I log in as "Castle Editor"
  #    And I go to the new_article page
  #    And I fill in "article_title" with "西瓜被打了催熟剂"
  #    And I fill in "article_content" with "本报讯，今日很多西瓜都被打了催熟剂"
  #    #And I follow "添加图片"
  #    #And I fill in "article_images_attributes_0_remote_picture_url" with "http://rubyonrails.org/images/rails.png" by Selenium
  #    And I fill in "article_images_attributes_0_remote_picture_url" with "http://rubyonrails.org/images/rails.png"
  #    And I fill in "article_images_attributes_0_description" with "Rails标志"
  #    And I press "发表"
  #    Then I should see "图片(1):"
  #    And I should see "Rails标志"

  Scenario: One can register as a new user
    When I go to the new_user page
    And I fill in "user_email" with "test_regiser@yin11.com"
    And I fill in "user_password" with "simplepassword"
    And I fill in "user_password_confirmation" with "simplepassword"
    And I press "注册"
    When I go to the login page
    And I fill in "email" with "test_regiser@yin11.com"
    And I fill in "password" with "simplepassword"
    And I press "登入"
    Then I should see "div" whose id is "control_panel"


