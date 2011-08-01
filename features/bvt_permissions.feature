Feature: usage about permissions
  Different permission for registered user and guest

  Background:
    Given There are minimum seeds data

  Scenario: guest can't post any reviews and will be asked to sign up
    When I go to the reviews page
    And I follow "+测评"
    Then I should be on the login page

  Scenario: registered user can post a review about food
    When I log in as "David User"
    And I go to the reviews page
    And I follow "+测评"
    Then I should see "新测评"

  Scenario: guest and normal user can't post any articles and will be asked to sign up
    When I go to the new_admin_article page
    Then I should be on the login page

    When I log in as "David User"
    And I go to the new_admin_article page
    Then I should be on the home page

  Scenario: editor can post a article about food
    When I log in as "Castle Editor"
    And I go to the admin_articles page
    And I follow "发表新文章"
    Then I should see "新文章"


  Scenario: unregistered user can't visit profile page. And normal user, editor and admin can
    When I go to David's profile page
    Then I should be on the login page

    When I log in as "David User"
    When I go to David's profile page
    Then I should be on David's profile page

    When I log in as "Castle Editor"
    When I go to Castle's profile page
    Then I should be on Castle's profile page

    When I log in as "Ray Admin"
    When I go to Ray's profile page
    Then I should be on Ray's profile page