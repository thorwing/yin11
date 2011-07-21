Feature: smoke tests for Tips
  On the tips page, it shows all recent updated tips and hot tips
  User can search for tip by using keywords
  User can create a tip
  User can edit others tip, and the change will be stored in revision, it will not be used immediately
  Admin can merge two tips

  Background:
    Given There are minimal testing records

  Scenario: On the tips page, it shows all recent updated tips and hot tips
    When I log in as "David User"
    And I go to the tips page
    Then I should see "最近更新的锦囊"
    And I should see "热门锦囊"
    And I should see "我参与的锦囊"
    And I should see "我收藏的锦囊"
    And I press "搜索"

  Scenario Outline: User can search for tip by using its title or keywords
    Given There is a simple tip

    When I search tips for "<search>"
    Then I should see "<search>" within "#search_results"

    Examples:
    | search        |
    | 西瓜判熟技巧  |
    | 西瓜 处理技巧 |

  Scenario: User can collect a tip
    Given the following tip exists:
    |     title      | content                                                                                   |
    | 瘦肉精猪肉目测 | 首先，看猪肉是否具有脂肪(猪油)，如猪肉在皮下就是瘦肉或仅有少量脂肪，则可能含有“瘦肉精”。|

    When I log in as "David User"
    And I go to the tips page
    And I follow "瘦肉精猪肉目测"
    And I follow "收藏锦囊"
    When I go to the tips page
    Then I should see "瘦肉精猪肉目测" within "#tips_collected_by_me"
    When I go to the home page
    Then I should see "瘦肉精猪肉目测"

  Scenario: User can create a tip only if it not exits
    When I log in as "David User"

    When I search tips for "辨别西瓜是否含有催熟剂"
    Then I should see "没有找到标题为<辨别西瓜是否含有催熟剂>的锦囊"
    When I follow "辨别西瓜是否含有催熟剂"
    Then I should see "创建锦囊"
    And I fill in "tip_content" with "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
    And I press "完成"
    Then I go to the tips page
    And I should see "我参与的锦囊"
    And I should see "辨别西瓜是否含有催熟剂" within "#tips_written_by_me"

    When I search tips for "辨别西瓜是否含有催熟剂"
    Then I should not see "没有找到标题为<辨别西瓜是否含有催熟剂>的锦囊"
    And I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"

  Scenario: User can edit others tip, and the change will be stored in revision, it will not be used immediately
    When I log in as "David User"
    And I post a simple tip

    When I log in as "Kate Tester"
    When I go to the tips page
    And I should see "辨别西瓜是否含有催熟剂"
    And I follow "辨别西瓜是否含有催熟剂"
    And I follow "编辑"

    And I fill in "tip_content" with "随便改改,恶作剧，字数补丁。"
    And I press "完成"

    When I search tips for "辨别西瓜是否含有催熟剂"
    Then I should see "随便改改,恶作剧，字数补丁。"
    And I should not see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"

  Scenario: The author can restore a version of tip
     When I log in as "David User"
    And I post a simple tip

    When I log in as "Kate Tester"
    When I go to the tips page
    And I follow "辨别西瓜是否含有催熟剂"
    And I follow "编辑"
    And I fill in "tip_content" with "随便改改,恶作剧，字数补丁。"
    And I press "完成"

    And I log out
    And I log in as "David User"
    And I go to the tips page
    And I follow "辨别西瓜是否含有催熟剂" within "#tips_written_by_me"
    Then I should see "随便改改,恶作剧，字数补丁。"
    Then I follow "查看改动记录"
    Then I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
    And I follow "恢复到此版本"
    And I go to the tips page
    And I follow "辨别西瓜是否含有催熟剂" within "#tips_written_by_me"
    Then I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"

  Scenario: Only Admin can delete tip
    Given the following tip exists:
    |     title      | content                                                                                   |
    | 瘦肉精猪肉目测 | 首先，看猪肉是否具有脂肪(猪油)，如猪肉在皮下就是瘦肉或仅有少量脂肪，则可能含有“瘦肉精”。|

    When I log in as "Ray Admin"
    And I go to the admin_tips page



