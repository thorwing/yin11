Feature: products listed on home page
  主页上将会按主题来展示商品（冬令进补，母婴滋补，白领强健）
  访客可以看到主页上的推荐商品专栏(商品为主体，用户对商品的评论将和商品一起被展示在主页上通过评论，评分,人工制定来选)
  访客可以看到主页上的商品与体验专栏：体验为主体，展示用户对产品的分享
  访客可以在主页上搜索到商品

  Background:
    Given There are minimum seeds data
    And There are some sample products

  Scenario: 主页上将会按主题来展示商品

  Scenario: 访客可以看到主页上的推荐商品专栏
    When I go to the home page
    Then I should see the following elements:
      | #recommended_products |
