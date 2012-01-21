Feature: display topics to users
  推荐的策划会被列在主页上（策划中最受推荐的产品也会一起显示）
  在策划的索引页面，策划会被列显示
  在策划项中，相关商品将以分数来排序
  编辑,在策划的详细页面，和策划相关（通过标签）的所有产品将会被显示
  访客，普通用户,在策划的详细页面,不会看到标签

  在策划页面，显示相关的食谱，和用户的分享
  在策划页面，和策划相关（通过标签）的推荐商品将会被显示

  Background:
    Given There are minimum seeds data
    And There are some topics
    And There are some products

  Scenario: 推荐的策划会被列在主页上
    When I go to the home page
    Then I should see "冬令进补" within "#hot_topics"
    And I should see "梅山猪" within "#hot_topics"

  Scenario: 在策划的索引页面，策划会被列显示
    When I go to the topics page
    Then I should see "冬令进补"
    And I follow "冬令进补"
    And I should see "梅山猪"

  Scenario: 在策划项中，相关商品将以分数来排序
    When I go to the topics page
    And I follow "冬令进补"
    Then I should see "梅山猪"

  Scenario Outline: 访客，普通用户,在策划的详细页面,不会看到标签
    When I log in as "<user>"
    And I go to the topics page
    And I follow "冬令进补"
    Then I should not see "a" whose "text" is "鸡"
    Then I should not see "a" whose "text" is "鸭"
    Then I should not see "a" whose "text" is "鱼"
    Then I should not see "a" whose "text" is "猪肉"

    Examples:
    | user |
    | Castle Editor |
    | Mighty Admin  |

  Scenario: 在策划页面，显示相关的食谱，和用户的分享


  Scenario: 在策划页面，和策划相关（通过标签）的推荐商品将会被显示
