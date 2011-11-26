#encoding utf-8

Feature: modify a vendor
  访客和注册用户不可以改变卖方信息
  编辑,管理员可以修改卖方信息

  Background:
    Given There are minimum seeds data

    Scenario Outline: 访客和注册用户不可以改变卖方信息
      Given the following vendor exists:
      | name   |
      | 农工商 |
      When I log in as "<user>"
      And I go to the vendors page
      And I follow "农工商"
      And I should not see "编辑"

          Examples:
    | user |
    | Guest |
    | David User |

     Scenario Outline: 访客和注册用户不可以改变卖方信息
      Given the following vendor exists:
      | name   |
      | 农工商 |
      When I log in as "<user>"
      And I go to the vendors page
      And I follow "农工商"
      And I should see "编辑"
      And I follow "编辑"
      And I fill in "vendor_name" with "农工商超市"
      And I press "完成"
      And I go to the vendors page
      Then I should see "农工商超市"

      Examples:
      | user |
      | Castle Editor |
      |Mighty Admin|

