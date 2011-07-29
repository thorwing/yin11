Feature: admin tips

  Background:
    Given There are minimum seeds data

  Scenario: Only Admin can delete tip
     Given the following tip exists:
     |     title      | content                                                                                   |
     | 瘦肉精猪肉目测 | 首先，看猪肉是否具有脂肪(猪油)，如猪肉在皮下就是瘦肉或仅有少量脂肪，则可能含有“瘦肉精”。|

     When I log in as "Ray Admin"
     And I go to the admin_tips page
#    TODO



  Scenario: Admin can disable/enable tips by single click
    Given the following tip exists:
     |     title      | content                                                                                   | tags_string |
     | 瘦肉精猪肉目测 | 首先，看猪肉是否具有脂肪(猪油)，如猪肉在皮下就是瘦肉或仅有少量脂肪，则可能含有“瘦肉精”。| 猪肉        |

    When I search for "猪肉"
    Then I should see "瘦肉精猪肉目测"
    When I log in as "Ray Admin"
    When I go to the admin_tips page
    And I follow "toggle_link" within ".toggle.enabled.on"
    When I search for "猪肉"
    Then I should not see "瘦肉精猪肉目测"
