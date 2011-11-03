#incoding utf-8
   @focus
Feature: Index articles

Background:
    Given There are minimum seeds data
    And There are some sample articles

#  @javascript
Scenario Outline: 用户可以看到新闻列表
    When I go to the articles page
    And I should see "<link_name>" within "<div_name>"
    When I follow "<link_name>"
    Then I should see "<check_content>"

    Examples:
      | link_name       |  check_content |  div_name |
      | 三聚氰胺再现上海 |       三聚氰胺又再次出现在了上海，市民们很担心 | #news_list |
      | 关爱心脏：5种减少盐摄入量的方法  |     盐的摄入量过高会导致高血压 | #recommended_list |

#Scenario: 用户可以看到专题列表
#    When I go to the articles page
#    And I should see "关爱心脏：5种减少盐摄入量的方法" within "#recommended_list"
#    When I follow "关爱心脏：5种减少盐摄入量的方法"
#    Then I should see "盐的摄入量过高会导致高血压"