Feature: modify topics
  编辑，管理员可以添加专题
  访客，普通用户不可以添加专题
  编辑，管理员可以修改专题
  访客，普通用户不可以修改策划
  编辑，管理员可以为策划制定相关的标签（相关的产品将会被显示在主页上）
  编辑，管理员可以删除策划
  访客，普通用户不可以删除策划

  Background:
    Given There are minimum seeds data
    And There are some topics
    And There are some products

  Scenario Outline: 编辑，管理员可以添加策划
    When I log in as "<user>"
    And I go to the me page
    And I follow "+策划"
    Then I should be on the new_topic page
    When I fill in "topic_title" with "茁壮成长"
    And I fill in "topic_tags_string" with "蟹,羊肉"
    And I press "完成"
    And I go to the topics page
    Then I should see "茁壮成长"

    Examples:
    | user |
    | Castle Editor |
    | Mighty Admin  |

  Scenario Outline: 访客，普通用户不可以添加策划
    When I log in as "<user>"
    And I go to the me page
    Then I should not see "+策划"
    When I go to the new_topic page
    Then I should not be on the new_topic page

    Examples:
    | user |
    | Guest |
    | David User |

  Scenario Outline: 编辑，管理员可以修改策划
    When I log in as "<user>"
    And I follow "冬令进补" of kind "topics"
    And I follow "修改"
    And I fill in "topic_title" with "野蛮生长"
    And I press "完成"
    And I go to the topics page
    Then I should see "野蛮生长"

    Examples:
    | user |
    | Castle Editor |
    | Mighty Admin  |

  Scenario Outline: 访客，普通用户不可以修改策划
    When I log in as "<user>"
    Then I can't "修改" "冬令进补" of kind "topics"

    Examples:
    | user |
    | Guest |
    | David User |


  Scenario Outline: 编辑，管理员可以为策划制定相关的标签（相关的产品将会被显示在主页上）
    When I log in as "<user>"
    And I "修改" the "冬令进补" of kind "topics"
#    And I should be on the edit_topic page
    And I fill in "topic_tags_string" with "鸡"
    And I press "完成"
    And I follow "冬令进补" of kind "topics"
    Then I should see "苏北草母鸡"

    Examples:
    | user |
    | Mighty Admin  |
    | Castle Editor |


  Scenario Outline: 编辑，管理员可以删除策划
    When I log in as "<user>"
    And I "删除" the "冬令进补" of kind "topics"
    When I go to the topics page
    Then I should not see "冬令进补"

    Examples:
    | user |
    | Castle Editor |
    | Mighty Admin  |

  Scenario Outline: 访客，普通用户不可以删除策划
    When I log in as "<user>"
    Then I can't "删除" "冬令进补" of kind "topics"

    Examples:
    | user |
    | Guest |
    | David User |
