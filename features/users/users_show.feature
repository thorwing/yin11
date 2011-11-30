Feature: show users
  在用户页面，可以所有的用户，并且能够分辨他是不是达人
  在用户页面，可以看到来自热门用户（达人）的分享（并不一定是热门分享）

  Background:
    Given There are minimum seeds data

  Scenario: 在用户页面，可以看到来自热门用户（达人）的分享（并不一定是热门分享）
    When I go to the users page
    Then I should see "Blade" within "master"
    And I should see "David" within "user"

  Scenario: 看到来自热门用户（达人）的分享（并不一定是热门分享）
    Given There are some products
    When I log in as "Blade Master"
    And I post a simple review for "梅山猪" with "非常香的猪肉"
    And I log out
    When I go to the users page
    Then I should see "非常香的猪肉"
