Feature: usage about permissions
  Different permission for registered user and guest

  Background:
    Given There is a "Tester"
    And There is a "Editor"
    And There is a "Admin"

  Scenario: guest can't post any reviews and will be asked to sign up
    When I go to the reviews page
    And I follow "发表新评论"
    Then I should be on the log_in page

  Scenario: registered user can post a review about food
    When I log in as "Tester"
    And I go to the reviews page
    And I follow "发表新评论"
    Then I should see "新评论"

  Scenario: guest and normal user can't post any articles and will be asked to sign up
    When I go to the articles page
    And I follow "发表新文章"
    Then I should be on the log_in page

    When I log in as "Tester"
    And I go to the articles page
    And I follow "发表新文章"
    Then I should be on the log_in page

  Scenario: editor can post a article about food
    When I log in as "Editor"
    And I go to the articles page
    And I follow "发表新文章"
    Then I should see "新文章"

  Scenario: unregistered user can't visit profile page. And normal user, editor and admin can
    When I go to the profile page
    Then I should be on the log_in page

    When I log in as "Tester"
    When I go to the profile page
    Then I should be on the profile page

    When I log in as "Editor"
    When I go to the profile page
    Then I should be on the profile page

    When I log in as "Admin"
    When I go to the profile page
    Then I should be on the profile page