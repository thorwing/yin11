Feature: show details of an article
  文章的详细信息包括标题，内容，作者，来源，图片等等
  注册用户，编辑，管理员可以对一篇文章投票（赞，贬）
  访客不可以对一篇文章投票
  推送文章的动态到关心的用户

  Background:
    Given There are minimum seeds data


  Scenario: 文章的详细信息包括标题，内容，作者，来源，图片等等
    Given There are some articles
    When I view an article named "三聚氰胺再现上海"
    Then I should see the following elements:
    | #article_content |
    | #article_source |
    And I should see "三聚氰胺又再次出现在了上海，市民们很担心。" within "#article_content"
    #| #article_images |    when @article.images.size > 0
  #    | #article_author |

  @javascript
  Scenario Outline: 注册用户，编辑，管理员可以对一篇文章投票（赞，贬）
    Given There are some articles
    When I log in as "<user>"
    And I view an article named "三聚氰胺再现上海"
    Then I should see "div" whose "class" is "vote_fields"
    When I follow "up" within ".vote_fields"
    Then I should see "<voting_weight>" within ".vote_fields"

    Examples:
    | user | voting_weight |
    | David User | 1 |
    | Castle Editor | 3 |
    | Mighty Admin  | 5 |

  Scenario: 访客不可以对一篇文章投票
    Given There are some articles
    When I view an article named "三聚氰胺再现上海"
    Then I should not see "div" whose "class" is "vote_fields"

    @focus
    @javascript
  Scenario: 推送文章的动态到关心的用户
    Given There are some groups
    When I log in as "David User"
     And I follow "饭桌"

     And I follow "西瓜守望者"
     Then show me the page
     And I follow "加入"
     And I log out

    When I log in as "Castle Editor"
      And I post an article with:
      | title | content | tags | type |
      | 土豆刷绿漆，冒充西瓜  | 今日，A城警方在B超市，查获了一批疑似用土豆刷上油漆冒充的西瓜。 | 西瓜 |  news |
      And I log out

    When I log in as "David User"
      And I go to the me page
      And I follow "用户动态"
      And I should see "今日，A城警方在B超市，查获了一批疑似用土豆刷上油漆冒充的西瓜。"



