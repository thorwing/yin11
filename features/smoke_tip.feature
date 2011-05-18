Feature: smoke tests for Tips
  On the tips page, it shows all recent updated tips and hot tips
  User can search for tip by using keywords
  User can create a tip
  User can vote for a tip
  User can edit others tip, and the change will be stored in revision, it will not be used immediately
  Admin can merge two tips

  Background:
    Given There is a "David User"
    And There is a "Kate Tester"
    And There are minimal testing records

  Scenario: On the tips page, it shows all recent updated tips and hot tips
    When I log in as "David User"
    And I go to the tips page
    Then I should see "最近更新的贴士"
    And I should see "热门贴士"
    And I should see "我参与的贴士"
    And I should see "我收藏的贴士"
    And I press "搜索"

  Scenario Outline: User can search for tip by using its title or keywords
    Given There is a sample tip

    When I search tips for "<search>"
    Then I should see "西瓜判熟技巧" within "#search_results"

    Examples:
    | search        |
    | 西瓜判熟技巧  |
    | 西瓜 处理技巧 |

  Scenario: User can create a tip only if it not exits
    When I log in as "David User"

    When I search tips for "辨别西瓜是否含有催熟剂"
    Then I should see "没有找到标题为<辨别西瓜是否含有催熟剂>的贴士"
    And I should see "欢迎您创建:"
    And I should see "食物处理贴士: <辨别西瓜是否含有催熟剂>"
    And I should see "食物测评贴士: <辨别西瓜是否含有催熟剂>"
    When I follow "食物测评贴士: <辨别西瓜是否含有催熟剂>"
    Then I should see "辨别西瓜是否含有催熟剂" within "div.field"
    And I fill in "content" with "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
    And I press "完成"
    Then I go to the tips page
    And I should see "我参与的贴士"
    And I should see "辨别西瓜是否含有催熟剂" within "#tips_participated_by_me"

    When I search tips for "辨别西瓜是否含有催熟剂"
    Then I should not see "没有找到标题为<辨别西瓜是否含有催熟剂>的贴士"
    And I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"

  Scenario: User can vote for a tip
    When I log in as "David User"
    And I post a sample tip

    When I log in as "Kate Tester"
    And I search tips for "辨别西瓜是否含有催熟剂"
    Then I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
    When I follow "up" within ".tip_item"
    Then I should see "辨别西瓜是否含有催熟剂" within "#recent_tips"
    And I should see "1" within "#recent_tips"

  @focus
  Scenario: User can edit others tip, and the change will be stored in revision, it will not be used immediately
    When I log in as "David User"
    And I post a sample tip

    When I log in as "Kate Tester"
    When I go to the tips page
    And I follow "辨别西瓜是否含有催熟剂"
    And I follow "编辑"

    And I fill in "content" with "随便改改，恶作剧"
    And I press "完成"

    When I search tips for "辨别西瓜是否含有催熟剂"
    Then I should see "随便改改，恶作剧"
    And I should not see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"

  @focus
  Scenario: Admin can merge two tips


