Feature: smoke tests for Wiki
  User can search for a wiki page
  User can create a wiki page only if it not existed
  If a wiki page is not valid, then it will not be used in other module
  If there are multiple pages share the same item, then they should be linked

  Background:
    Given There is a "David User"
    And There is a "Kate Tester"
    And There are minimal testing records

  Scenario: User can search for a wiki page
    When I log in as "David User"
    And I go to the wiki page

