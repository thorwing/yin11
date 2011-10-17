Feature: tests for tags
   Background:
    Given There are minimum seeds data

   Scenario: I should see tags cloud on home page
     And I go to the home page
     Then I should not see "西瓜" within "#tag_cloud"

     When I log in as "David User"
     When I post a simple review without vendor
     And I go to the home page
     Then I should see "西瓜" within "#tag_cloud"