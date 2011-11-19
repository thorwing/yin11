Feature: Index articles
    用户可以看到新闻和专题列表
    注册用户/访客不能看到 未启用的 article

Background:
    Given There are minimum seeds data
    And There are some articles

Scenario Outline: 用户可以看到新闻和专题列表
    When I go to the articles page
    And I should see "<link_name>" within "<div_name>"
    When I follow "<link_name>"
    Then I should see "<check_content>"

    Examples:
      | link_name       |  check_content |  div_name |
      | 三聚氰胺再现上海 |       三聚氰胺又再次出现在了上海，市民们很担心 | #news_list |
      | 关爱心脏：5种减少盐摄入量的方法  |     盐的摄入量过高会导致高血压 | #recommended_list |

Scenario Outline: 注册用户/访客不能看到 未启用的 article
    When I log in as "<user>"
    And I go to the articles page
    Then I should see "三聚氰胺再现上海"
    And I log out
    And I log in as "Mighty Admin"
    And I disabled a article named "三聚氰胺再现上海"
    And I log out
    When I log in as "<user>"
    When I go to the articles page
    Then I should not see "三聚氰胺再现上海"

    Examples:
      | user        |
      | Guest       |
      | David User  |