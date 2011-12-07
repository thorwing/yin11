#encoding utf-8
Feature: smoke tests for Vendors
  访客和用户不可以进入创建商户页面
  访客和用户不可以创建商户
  编辑和管理员可以创建商户

  Background:
      Given There are minimum seeds data

  Scenario Outline: 访客和用户不可以进入创建商户页面
    When I log in as "<user>"
    When I go to the new_vendor page
    Then I should be on <url>

   Examples:
    | user | url |
    | Guest |  the login page |
    | David User | the home page |

  Scenario Outline: 访客和用户不可以创建商户
    When I log in as "<user>"
    And I go to the home page
    And I should not see "+商户"

    And I go to the vendors page
    And I should not see "+商户"

    Examples:
    | user |
    | Guest |
    | David User |

   Scenario Outline: 编辑和管理员可以创建商户
      When I log in as "<user>"
       And I go to the vendors page
      And I follow "+商户"
     Then I should be on the new_vendor page
     And I fill in "vendor_name" with "农工商超市"
      And I press "完成"
      And I go to the vendors page
      Then I should see "农工商超市"

    Examples:
    | user          |
    | Castle Editor |
    | Mighty Admin  |


