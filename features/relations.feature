Feature: tests for relationships

  Background:
    Given There are minimum seeds data

  @javascript
  Scenario: User can establish a relationship with a vendor
    Given the following vendor exists:
      | name       | city | street |
      | 农工商超市 | 上海 | 大华路 |
    When I log in as "David User"
    And I go to the vendors page
    And I follow "农工商超市"
    Then I should see "+关注"
    When I follow "+关注"
    Then I should see "-取消关注"

  @focus
  Scenario: User can cancel a relationship with a vendor
    Given the following vendor exists:
      | name       | city | street |
      | 农工商超市 | 上海 | 大华路 |
    When I log in as "David User"
    And I go to the vendors page
    And I follow "农工商超市"
    When I follow "+关注"

    And I go to the vendors page
    And I follow "农工商超市"
    And I follow "-取消关注"

    And I go to the vendors page
    And I follow "农工商超市"
    And I follow "+关注"

  @focus
  Scenario: User can follow a vendor and get corresponding reviews
    Given the following vendor exists:
      | name       | city | street |
      | 农工商超市 | 上海 | 大华路 |
    When I log in as "Kate Tester"
    And I post a review about vendor "农工商超市"
    
    When I log in as "David User"
    Then I should not see "买到烂西瓜"
    And I follow a vendor "农工商超市"
    When I go to the home page
    Then I should see "买到烂西瓜"


    
