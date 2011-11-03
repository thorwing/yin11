@focus show details of an article
Feature: articles
  文章的详细信息包括标题，内容，作者，来源，图片等等
  注册用户，编辑，管理员可以对一篇文章投票（赞，贬）
  访客不可以对一篇文章投票

  Background:
    Given There are minimum seeds data

  Scenario: 文章的详细信息包括标题，内容，作者，来源，图片等等
    Given the following article exists:
      | title            | content                            | tags_string |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |

    When I view an article with named "西瓜被打了催熟剂"
    Then I should see the following elements:
    | #article_title |
    | #article_content |
    | #article_author |
    | #article_source |
    | #article_images |

  @javascript
  Scenario Outline: 注册用户，编辑，管理员可以对一篇文章投票（赞，贬）
    Given the following article exists:
      | title            | content                            | tags_string |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |

    When I log in as "<user>"
    And I view an article with named "西瓜被打了催熟剂"
    Then I should see "div" whose "class" is "vote_fields"
    When I follow "up" within ".vote_fields"
    Then I should see "<voting_weight>" within ".vote_fields"

    Examples:
    | user | voting_weight |
    | David User | 1 |
    | Castle Editor | 3 |
    | Mighty Admin  | 5 |

  Scenario: 访客不可以对一篇文章投票
    Given the following article exists:
      | title            | content                            | tags_string |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |
    
    When I view an article with named "西瓜被打了催熟剂"
    Then I should not see "div" whose "class" is "vote_fields"
