@focus
Feature: create recipe
  用户,编辑和管理员可以新建菜谱,  个人主页上有新建菜谱的链接
  游客不可以新建菜谱
  添加菜谱时，步骤描述可以为空




  Background:
    Given There are minimum seeds data

    Scenario Outline: 用户,编辑和管理员可以新建菜谱
    When I log in as "<user>"
    When I go to the recipes page
    Then I should see "新菜谱"
    And I follow "新菜谱"
    Then I should be on the new_recipe page
    And I go to the me page
    Then I should see "+菜谱"
    And I follow "+菜谱"
    Then I should be on the new_recipe page

    Examples:
        | user        |
        | Castle Editor |
        | Mighty Admin  |
        | David User  |

    Scenario Outline:   游客不可以新建菜谱
    When I log in as "<user>"
    When I go to the recipes page
    Then I should not see "新菜谱"

    Examples:
        | user        |
        | Guest      |

