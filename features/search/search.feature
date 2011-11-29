
Feature: smoke tests for Search
  The search result should be useful

  Background:
    Given There are minimum seeds data


#  @javascript
#  Scenario: Item's score is considered according to popularity and tags
#    Given  There are some tips
#
#    When I log in as "David User"
#    And I go to the tips page
#    Then I should see "瘦肉精猪肉目测"
#    When I search for "猪肉"
#    Then I should see "瘦肉精猪肉目测"
#    When I search for "三聚氰胺"
#    Then I should see "三聚氰胺家庭检测法"


  Scenario: Hot items and recent item should have ribbons
    Given  There are some tips

    When I go to the home page
    Then I should see "img" whose "alt" is "Ribbon_recent"

#    When I log in as "David User"
#    And I go to the tips page
#    And I follow "瘦肉精猪肉目测"
#    And I follow "up"
#
#    And I go to the home page
#    Then I should see "瘦肉精猪肉目测" within "#items .hot"


  Scenario: Item about recent popular topics will be display on the home page
    Given  There are some tips
    Given There are some articles
    When I go to the home page
    Then I should see "瘦肉精猪肉目测"


  @javascript
  Scenario: User can search with tags
    And There are some articles

    When I search for "牛奶"
    Then I should see "三聚氰胺再现上海"


  @javascript
  Scenario: User can search with tags
    And There are some articles

    When I search for "上海"
    Then I should see "三聚氰胺再现上海"
    And I should not see "北京禁止商贩往水里兑牛奶"


  Scenario: A default search will be prepared based on hot tags
    Given the following articles exists:
      | title            | content                            | tags_string | enabled |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜        | true    |
    When I go to the home page
    Then I should see "西瓜被打了催熟剂"
    #TODO
    When I press "搜索"
    Then I should see "西瓜"


  @javascript
  Scenario: User can search for a tag
    Given There are some reviews
    When I search for "牛奶"
    Then I should see "牛奶坏了" within "#items_list"


  Scenario: User can search for vendors
    Given the following vendors exists:
      | name       | city | street | enabled |
      | 农工商超市 | 上海 | 大华路 | true    |
      | 家乐福超市 | 上海 | 真华路 | false   |
    When I go to the vendors page
    Then I should see "农工商超市"
    And I fill in "query" with "农工商超市"
    And I press "搜索"
    Then I should see "农工商超市"

    When I go to the vendors page
    Then I should not see "家乐福超市"
    And I fill in "query" with "家乐福超市"
    And I press "搜索"
    And I should not see "家乐福超市"






