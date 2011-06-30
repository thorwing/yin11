Feature: smoke tests for Recommendations
  User can create, edit(only his own) recommendation.
  User can delete his recommendation.
  Recommendation is food-oriented, location-oriente

Background:
    Given There are minimal testing records

  @focus
  Scenario: User can post recommendation from homepage, and he create a new vendor ( it will be better if we can make a popup window here)
    When I log in as "David User"
    And I go to the home page
    Then I should see "分享我的健康一餐" within "#actions_menu"
    When I follow "分享我的健康一餐"
    Then I should see "分享我的健康一餐"
    And I should see "您刚刚吃了健康的一餐，食物安全，卫生，又有营养。现在将这健康一餐和大家一起分享吧！越多的用户喜爱您的分享，您将获得更多的积分。"
    And I should see "在何时何地，您吃了什么食物？您用了什么手段来确保这一餐是安全又卫生的？"


