Feature: user can register
  访客可以注册为用户，注册后可以登录
  如果填写的信息有误，用户将不可以注册（停留在注册页，显示出错信息）
  同一个IP地址（地址段）不可以在半小时内连续注册
  在注册后，用户将被重定向到profile页，去完善个人信息

  Background:
    Given There are minimum seeds data
    And There are some groups

  Scenario: 访客可以注册为用户，注册后可以登录
    When I register as a new user "Geek" with email "unique@test.com"
    When I log out
    And I log in with email "unique@test.com" and password "test123"
    Then I should be on the home page

  Scenario: 如果填写的信息有误，用户将不可以注册

  Scenario: 同一个IP地址（地址段）不可以在半小时内连续注册
    When I register as a new user "Geek" with email "unique@test.com"
    And I register as a new user "Geek_no2" with email "unique_2@test.com"
    Then I should see "你已经在最近注册了一个帐号啦"

  Scenario: 在注册后，用户将被重定向到profile页，去完善个人信息
    When I register as a new user "Geek" with email "unique@test.com"
    Then I should be on Geek's profile editing page
    And I should see "西瓜守望者"
    When I press "下一步"
    Then I should see "昵称"
    And I should see "换一张头像"
    

