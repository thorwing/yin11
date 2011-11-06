Feature: articles listed on home page
  访客可以在主页上看到一些新闻
  访客可以在主页上看到一些专题
  访客可以在主页上搜索到文章

  Background:
    Given There are minimum seeds data
    And There are some sample articles

  Scenario: 访客可以在主页上看到一些新闻
    When I go to the home page