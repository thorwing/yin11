Feature: tests for Profile

  Background:
    Given There are minimum seeds data

  Scenario: Guest can't go to the profile page
    When I go to David's profile page
    Then I should be on the login page

    When I log in as "David User"
    And I go to David's profile page
    Then I should be on David's profile page

  Scenario: User can access the profile page
    When I log in as "David User"
    And I go to David's profile page
    Then I should be on David's profile page
    And I should see "基本信息"

  Scenario: User can edit the profile step by step
    When I log in as "David User"
    And I go to David's profile page
    And I follow "设置" within ".actions"
    Then I should see "我是..."
    When I press "下一步"
    Then I should see "昵称"
    Then I should see "换一张头像"
    When I press "完成"
    Then I should be on the home page


#  Scenario: User can hide the watching tags panel and it will not shown again on the home page
#    When I log in as "David User"
#    And I follow "hide_link" within "#watching_tags_panel"
#    When I go to the home page
#    Then I should not see "div" whose id is "#watching_tags_panel"

#  Scenario: User can hide the watching locations panel and it will not shown again on the home page
#    When I log in as "David User"
#    And I follow "hide_link" within "#watching_locations_panel"
#    When I go to the home page
#    Then I should not see "div" whose id is "#watching_locations_panel"

#  Scenario: User can hide the collected tips panel and it will not shown again on the home page
#    When I log in as "David User"
#    And I follow "hide_link" within "#collected_tips_panel"
#    When I go to the home page
#    Then I should not see "div" whose id is "#collected_tips_panel"

#  Scenario: User can hide the joined groups panel and it will not shown again on the home page
#    When I log in as "David User"
#    And I follow "hide_link" within "#joined_groups_panel"
#    When I go to the home page
#    Then I should not see "div" whose id is "#joined_groups_panel"

  Scenario: User can have a short introduction
    When I log in as "David User"
    And I go to David's profile page
    And I follow "设置" within ".actions"
    Then I should see "我是..."
    When I press "下一步"
    Then I should see "昵称"
    Then I should see "个人简介"
    And I fill in "profile_biography" with "I am a user"
    And I press "完成"

    When I log in as "David User"
    And I go to David's user page
    Then I should see "I am a user"


  Scenario: User can change a avatar
    When I log in as "David User"
    And I go to David's profile page
    Then I should see "img" whose "alt" is "Default_user"

    And I follow "设置" within ".actions"
    When I press "下一步"
    And I upload a file "test.png" to "user_avatar"
    And I press "完成"
    When I go to David's profile page
    Then I should not see "img" whose "alt" is "Default_user"
