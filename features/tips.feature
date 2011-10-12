#Feature: smoke tests for Tips
#  On the tips page, it shows all recent updated tips and hot tips
#  User can search for tip by using keywords
#  User can create a tip
#  User can edit others tip, and the change will be stored in revision, it will not be used immediately
#
#  Background:
#    Given There are minimum seeds data
#
#
#  Scenario: Only Editor can create tip
#    When I log in as "David User"
#    Then I should not see "+锦囊"
#    When I go to the new_tip page
#    Then I should be on the home page
#
#    When I log in as "Castle Editor"
#    Then I should see "+锦囊"
#    When I go to the new_tip page
#    Then I should be on the new_tip page
#
#  Scenario: User can't post tip
#    When I log in as "David User"
#    And I go to the new_tip page
#    Then I should be on the home page
#    And I should see "此操作需要编辑的权限， 请留意我们的公告来获知如何提升权限。"
#
#  Scenario: On the tips page, it shows all recent updated tips and hot tips
#    When I log in as "David User"
#    And I go to the tips page
#    Then I should see "所有锦囊"
#    And I press "搜索" within "#content_area"
#
#  Scenario Outline: User can search for tip by using its title or keywords
#    Given There is a simple tip
#
#    When I go to the tips page
#    Then I should see "西瓜判熟技巧"
#
#    When I search for "<search>"
#    Then I should see "<search>" within "div.two_columns_container"
#
#    Examples:
#    | search        |
#    | 西瓜判熟技巧  |
#    | 西瓜 |
#
#  Scenario: User can collect a tip
#    Given the following tip exists:
#    |     title      | content                                                                                   |
#    | 瘦肉精猪肉目测 | 首先，看猪肉是否具有脂肪(猪油)，如猪肉在皮下就是瘦肉或仅有少量脂肪，则可能含有“瘦肉精”。|
#
#    When I log in as "David User"
#    And I go to the tips page
#    And I follow "瘦肉精猪肉目测"
#    And I follow "收藏"
#    When I go to the home page
#    Then I should see "瘦肉精猪肉目测" within "#control_panel"
#
#  Scenario: User can edit others tip, and the change will be stored in revision
#    When I log in as "Castle Editor"
#    And I post a simple tip
#
#    When I log in as "Ray Admin"
#    When I go to the tips page
#    And I should see "辨别西瓜是否含有催熟剂"
#    And I follow "辨别西瓜是否含有催熟剂"
#    And I follow "编辑"
#
#    And I fill in "tip_content" with "随便改改,恶作剧，字数补丁。"
#    And I press "完成"
#
#    When I search for "辨别西瓜是否含有催熟剂"
#    And I follow "辨别西瓜是否含有催熟剂"
#    Then I should see "随便改改,恶作剧，字数补丁。"
#    And I should not see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
#
#  Scenario: Revision should also be valid
#    When I log in as "Castle Editor"
#    And I post a simple tip
#
#    When I go to the tips page
#    And I follow "辨别西瓜是否含有催熟剂"
#    And I follow "编辑"
#    And I fill in "tip_content" with "字数不足"
#    And I press "完成"
#     When I go to the tips page
#    And I follow "辨别西瓜是否含有催熟剂"
#    Then I follow "改动历史"
#    Then I should not see "字数不足"
#
#
#
#  Scenario: The author can restore a version of tip
#    When I log in as "Castle Editor"
#    And I post a simple tip
#
#    When I log in as "Ray Admin"
#    When I go to the tips page
#    And I follow "辨别西瓜是否含有催熟剂"
#    And I follow "编辑"
#    And I fill in "tip_content" with "随便改改,恶作剧，字数补丁。"
#    And I press "完成"
#
#    And I log out
#    And I log in as "Castle Editor"
#    And I go to the tips page
#    And I follow "辨别西瓜是否含有催熟剂"
#    Then I should see "随便改改,恶作剧，字数补丁。"
#    Then I follow "改动历史"
#    Then I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
#    And I follow "恢复到此版本"
#    And I go to the tips page
#    And I follow "辨别西瓜是否含有催熟剂"
#    Then I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
#
#  Scenario: unsuccessful operation will not create revision
#    When I log in as "Castle Editor"
#    And I go to the new_tip page
#    And I fill in "tip_title" with "辨别西瓜是否含有催熟剂"
#    And I fill in "tip_content" with "123456789"
#    And I press "完成"
#    Then I should see "好像表单中有一些错误，要不您再仔细看看？"
#    When I fill in "tip_content" with "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
#    And I press "完成"
#    Then I should not see "好像表单中有一些错误，要不您再仔细看看？"
#
#    And I follow "改动历史"
#    Then I should not see "123456789"
#    And I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
#    And I should not see "恢复到此版本"
#
#
