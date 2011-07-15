
Feature: smoke tests for Profile

  Background:
    Given There are minimal testing records

  Scenario: Guest can't go to the profile page
    When I go to the profile_show page
    Then I should be on the log_in page
    When I go to the profile_edit page
    Then I should be on the log_in page

    When I log in as "David User"
    And I go to the profile_show page
    Then I should be on the profile_show page
     And I go to the profile_edit page
    Then I should be on the profile_edit page

  Scenario: User can access the profile show page via the top menu
    When I log in as "David User"
    And I follow "个人资料" within the "#top_menu"
    Then I should be on the profile_show page
    And I should see "我的徽章"
    And I should see "我最近发表"
    When I follow "修改"
    Then I should be on the profile_edit page

  @javascript
  Scenario: User can add a location to watch



