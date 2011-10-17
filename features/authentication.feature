Feature: tests for authentication logic

  Background:
    Given There are minimum seeds data

  Scenario: Guest can visit the entry page
      When I go to the home page
      And I should be on the home page


  Scenario: User should not see quick_login on the login page
    When I go to the login page
    Then I should not see "quick_auth"