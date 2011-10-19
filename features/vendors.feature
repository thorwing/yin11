Feature: smoke tests for Vendors

  Background:
      Given There are minimum seeds data

  Scenario: Guest can see all vendros
    Given the following vendor exists:
      | name       | city | street |
      | 农工商超市 | 上海 | 大华路 |
    When I go to the vendors page
    Then I should see "农工商超市"


  Scenario: User can create vendor via home page and vendors page
    When I log in as "David User"
    And I go to the home page
    And I follow "+商户"
    And I fill in "vendor_name" with "农工商超市"
    And I fill in "vendor_street" with "大华路"
    And I press "完成"
    And I go to the mine_vendors page
    Then I should see "农工商超市"

    And I go to the vendors page
    Then I follow "+商户"
    When I fill in "vendor_name" with "肯德基"
    And I fill in "vendor_street" with "大华二路"
    And I press "完成"
    And I go to the mine_vendors page
    Then I should see "肯德基"


  @javascript
  Scenario: User can create vendor and set a type for it
    When I log in as "David User"
    When I go to the new_vendor page
#    Then "餐饮" should be selected for "vendor_type"
    When I select "餐饮" from "vendor_category"
    And I fill in "vendor_name" with "鸡公煲"
    And I fill in "vendor_street" with "大华二路"
    And I press "完成"
    When I go to the mine_vendors page
    Then I should see "鸡公煲"
    And I should see "餐饮"

  Scenario: User's city will be detected when creating vendor
    When I log in as "David User"
    When I go to the new_vendor page
    Then "上海" should be selected for "select_province"
    Then "上海" should be selected for "select_city"

  @javascript
  Scenario: User can create a vendor that is in another city
    When I log in as "David User"
    When I go to the new_vendor page
    And I select "北京" from "select_province"
    And I select "北京" from "select_city"
    And I fill in "vendor_name" with "全聚德"
    And I fill in "vendor_street" with "前门"
    And I press "完成"

  Scenario: User can see the vendors he created
    When I log in as "David User"
    And I create a simple vendor
    When I go to the vendors page
    And I follow "我创建的商户"
    Then I should see "农工商超市"

    When I log in as "Kate Tester"
    When I go to the vendors page
    Then I should not see "农工商超市"


  Scenario: Quest can not create a vendor
    When I go to the new_vendor page
    Then I should be on the login page

  Scenario: Admin can approve a vendor
    When I log in as "David User"
    And I create a simple vendor

    When I log in as "Ray Admin"
    And I go to the administrator_vendors page
    And I follow "农工商超市"
    And I follow "编辑"
    And I check "vendor_enabled"
    And I press "完成"

    When I log in as "Kate Tester"
    When I go to the vendors page
    Then I should see "农工商超市"


  Scenario: Only admin can edit vendor if it is not locked
    Given the following vendor exists:
      | name       | city | street |
      | 农工商超市 | 上海 | 大华路 |
    Given the following vendor exists:
      | name       | city | street | enabled |
      | 家乐福超市 | 上海 | 真华路 | false   |

    When I log in as "Ray Admin"
    And I go to the administrator_vendors page
    And I follow "农工商超市"
    And I follow "编辑"
    Then I should see "编辑商户"

    When I go to the administrator_vendors page
    And I follow "家乐福超市"
    And I follow "编辑"
    Then I should see "编辑商户"

  Scenario: User can post error report for vendor's information
    Given the following vendor exists:
      | name       | city | street |
      | 农工商超市 | 上海 | 大华路 |
    When I go to the vendors page
    And I follow "农工商超市"
    And I follow "报错/纠正"

  Scenario: Only Editor or Admin can lock a vendor
    Given the following vendor exists:
      | name       | city | street |
      | 农工商超市 | 上海 | 大华路 |
    When I log in as "Ray Admin"
    And I go to the administrator_vendors page
    And I follow "农工商超市"
    And I follow "编辑"
    And I uncheck "vendor_enabled"

    And I press "完成"

    When I log in as "David User"
    And I go to the administrator_vendors page
    Then I should be on the home page





