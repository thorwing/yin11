Feature: User can vote for an item
  Background:
    Given There are minimum seeds data

  @javascript
  Scenario: User can vote for a article.
    Given the following article exists:
      | title            | content                            | tags_string |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |

    When I log in as "David User"
    Then I should see "西瓜被打了催熟剂"
    When I follow "up" within ".item.info"
    Then I should see "1" within ".item.info"

  @javascript
  Scenario: User can vote for a review.
    When I log in as "Kate Tester"
    And I go to the home page
    And I follow "+测评" within "#control_panel"
    And I fill in "review_title" with "买到烂西瓜"
    And I press "完成"

    When I log out
    And I log in as "David User"
    When I follow "up" within ".item.info"
    Then I should see "1" within ".item.info"

  Scenario: User can vote for a tip
    When I log in as "Kate Tester"
    And I post a simple tip

    When I log in as "David User"
    And I search tips for "辨别西瓜是否含有催熟剂"
#    Then I should see "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。"
    When I follow "up" within ".vote_fields"
    And I go to the tips page
    Then I should see "辨别西瓜是否含有催熟剂" within "#tips_list"
    And I should see "1" within "#tips_list"
