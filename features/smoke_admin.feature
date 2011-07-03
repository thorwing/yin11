Feature: smoke tests for Administration
  Editor and Admin can do some administration works
  They can edit/disable/delete articles
  They can edit/disable/delete reviews
  They can edit/disable/delete recommendations
  They can edit/disable/delete vendors
  They can edit/disable/delete badges
  Only Admin can manage users

  Background:
    Given There are minimal testing records

  Scenario Outline: Editor and Admin can edit/disable/delete articles
    Given the following article exists:
      | title            | content                            | tags_string | disabled |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜        | false    |

    When I go to the home page
    Then I should not see "西瓜被打了催熟剂"

    When I log in as "<user>"
    And I go to the admin_articles page
    Then I should see "西瓜被打了催熟剂"
    And I follow "西瓜被打了催熟剂"
    And I follow "启用"

    When I log out
    And I go to the home page
    Then I should see "西瓜被打了催熟剂"

    Examples:
    | user          |
    | Castle Editor |
    | Ray Admin     |

  Scenario: Only Admin can manage users
    When I go to the admin_users page
    Then I should be on the log_in page

    When I log in as "Kate Tester"
    Then I should be on the home page
    And I go to the admin_users page
    Then I should be on the home page

    When I log in as "Castle Editor"
    Then I should be on the home page
    And I go to the admin_users page
    Then I should be on the home page

    When I log in as "Ray Admin"
    Then I should be on the admin_users page
