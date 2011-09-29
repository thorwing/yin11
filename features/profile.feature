@foucs
Feature: tests for Profile

  Background:
    Given There are minimum seeds data

  Scenario: Guest can't go to the profile page
    When I go to David's profile page
    Then I should be on the login page

    When I log in as "David User"
    And I go to David's profile page
    Then I should be on David's profile page

  Scenario: User can access the profile show page
    When I log in as "David User"
    And I go to David's profile page
    Then I should be on David's profile page
    And I should see "基本信息"

  @focus
  Scenario: User can edit the profile step by step
    When I log in as "David User"
    And I follow "设置" within "#top_menu"
    Then I should see "我是..."
    When I press "下一步"
    Then I should see "昵称"
    Then I should see "换一张头像"
    When I press "下一步"
    Then I should see "主页订制"

#  Scenario: User can hide the watching tags panel and it will not shown again on the home page
#    When I log in as "David User"
#    And I follow "hide_link" within "#watching_tags_panel"
#    When I go to the home page
#    Then I should not see "div" whose id is "#watching_tags_panel"

  Scenario: User can hide the watching locations panel and it will not shown again on the home page
    When I log in as "David User"
    And I follow "hide_link" within "#watching_locations_panel"
    When I go to the home page
    Then I should not see "div" whose id is "#watching_locations_panel"

  Scenario: User can hide the collected tips panel and it will not shown again on the home page
    When I log in as "David User"
    And I follow "hide_link" within "#collected_tips_panel"
    When I go to the home page
    Then I should not see "div" whose id is "#collected_tips_panel"

  Scenario: User can hide the joined groups panel and it will not shown again on the home page
    When I log in as "David User"
    And I follow "hide_link" within "#joined_groups_panel"
    When I go to the home page
    Then I should not see "div" whose id is "#joined_groups_panel"





