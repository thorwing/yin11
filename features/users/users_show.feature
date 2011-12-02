Feature: show users
  在用户页面，可以所有的用户，并且能够分辨他是不是达人

  Background:
    Given There are minimum seeds data

  Scenario: 在用户页面，可以看到来自热门用户（达人）的分享（并不一定是热门分享）
    When I go to the users page
    Then show me the page
#    Then I should see "David" within "user"
    Then I should see "Blade" within ".master"