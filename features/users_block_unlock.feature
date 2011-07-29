Feature:
  User can view another user's basic information.
  and user can block another user, so he will see anything created by that user. Later on, user can unlock the user, then everything back to before.

  Background:
    Given There are minimum seeds data
    And I log in as "David User"
    And I post a simple review without vendor

  Scenario: User's name will be displayed in the item, and others can click the link to view his profile
    When I log out
    And I log in as "Kate Tester"
    And I go to the home page
    Then I should see "买到烂西瓜"
    And I should see "David"
    When I follow "买到烂西瓜"
    Then I should see "David"
    When I follow "David"
    Then I should be on David's user page
    And I should see "David"
    And I should see "阻止该用户"
    And I should not see "解除对该用户的阻止"

  Scenario: User can block and unlock another group member
    When I log out
    And I log in as "Kate Tester"
    And I go to the home page
    Then I should see "买到烂西瓜"
    And I follow "David"
    Then I should be on David's user page
    And I follow "阻止该用户"
    And I go to the home page
    Then I should not see "买到烂西瓜"


  Scenario: User can go to profile page and unlock another user
    When I log in as "Kate Tester"
    And I follow "David"
    And I follow "阻止该用户"

    When I go to Kate's profile page
    And I follow "David" within "#blocked_users_list"
    When I follow "解除对该用户的阻止"
    And I go to the home page
    Then I should see "买到烂西瓜"

  Scenario: User can go to a group page and unlock another user
    Given There are some sample groups
    When I log in as "David User"
    And I join the group "西瓜守望者"
    
    When I log out
    And I log in as "Kate Tester"
    And I join the group "西瓜守望者"
    And I follow "David"
    And I follow "阻止该用户"

    When I go to Kate's profile page
    And I follow "西瓜守望者"
    And I follow "David"
    And I follow "解除对该用户的阻止"
    And I go to the home page
    Then I should see "买到烂西瓜"