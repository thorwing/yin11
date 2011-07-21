Feature: smoke tests for Profile

  Background:
    Given There are minimal testing records

  Scenario: Guest can't go to the profile page
    When I go to David's profile page
    Then I should be on the login page

    When I log in as "David User"
    And I go to David's profile page
    Then I should be on David's profile page
    And I follow "修改"

  Scenario: User can access the profile show page via the top menu
    When I log in as "David User"
    And I follow "个人资料" within "#top_menu"
    Then I should be on David's profile page
    And I should see "我的徽章"
    And I should see "我最近发表"




