
Feature:
  User can view another user's basic information.

  Background:
    Given There are minimum seeds data
    And There are some sample groups

  Scenario: Guest can register as an user
    When I register as a new user "Geek" with email "unique@test.com"
    When I log out
    And I log in with email "unique@test.com" and password "test123"
    Then I should be on the home page

  Scenario: After registration, user becomes a normal user
    When I register as a new user "Geek" with email "unique@test.com"
    And I join the group "西瓜守望者"
    Then Confirm that "Geek" is in the group "西瓜守望者"

  Scenario: Same IP can't register two account in 0.5h
    When I register as a new user "Geek" with email "unique@test.com"
    And I register as a new user "Geek_no2" with email "unique_2@test.com"
    Then I should see "你已经在最近注册了一个帐号啦"

  Scenario: After registration, user will be redirect to perfect his profile
    When I register as a new user "Geek" with email "unique@test.com"
    Then I should be on Geek's profile editing page
    And I should see "西瓜守望者"
    When I press "下一步"
    Then I should see "昵称"
    And I should see "换一张头像"
    

