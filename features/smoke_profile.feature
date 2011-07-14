Feature: smoke tests for Profile

  Background:
    Given There are minimal testing records

  @focus
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
