Feature: smoke tests for Search
  The search result should be useful

  Background:
    Given There are minimal testing records

  @javascript
  Scenario: Item's score is considered according to popularity and tags
    Given  There are some sample tips

    When I log in as "David User"
    And I go to the tips page
    Then I should see "瘦肉精猪肉目测"
    When I search for "猪肉"
    Then I should see "瘦肉精猪肉目测"
    When I search for "三聚氰胺"
    Then I should see "三聚氰胺家庭检测法"


  Scenario: Hot items and recent item should have ribbons
    Given  There are some sample tips

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
    Given  There are some sample tips
    Given There are some sample articles
    When I go to the home page
    Then I should see "瘦肉精猪肉目测"

  @javascript
  Scenario: User can search with tags and locations
    Given  There are some sample tips
    When I go to the home page
    And I search for "牛奶 上海"
    Then I should see "三聚氰胺再现上海"

  @javascript
  Scenario: User can search for a tag
    When I search for "milk"
    Then I should see "milk tastes funny" within "#bad_items"






