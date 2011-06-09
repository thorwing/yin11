Feature: smoke tests for Recommendations
  User can create, edit(only his own) recommendation.
  User can delete his recommendation.
  Recommendation is food-oriented, location-oriente

Background:
    Given There is a "David User"
    And There is a "Kate Tester"
    And There are minimal testing records

  @focus
  Scenario: User can post recommendation from homepage, and he create a new vendor ( it will be better if we can make a popup window here)
    When I log in as "David User"
    And I go to the home page
    Then I should see "分享我的健康一餐" within "#actions_menu"
    When I follow "分享我的健康一餐"
    Then I should see "分享我的健康一餐"


