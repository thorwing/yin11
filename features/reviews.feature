@focus
Feature: tests for reviews

  Background:
    Given There are minimum seeds data

  Scenario: User can add review for a product
    Given There are some sample products
    When I log in as "David User"
    And I go to the products page
    And I follow "苏北草母鸡"
    Then I should see "input" whose id is "review_title"
    And I should see "input" whose id is "review_content"

    When I fill in "review_title" with "用来炖鸡汤不错"
    And I press "发表测评"

    When I go to the products page
    And I follow "苏北草母鸡"
    Then I should see "用来炖鸡汤不错"




