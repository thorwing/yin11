Feature: smoke tests for Vendors
  User can search for vendors
  User can create vendor if it didn't exist
  User can edit vendor if it is not locked
  User can upload images for vendor
  Only Admin can lock a vendor
  Only Admin can delete a vendor

  Background:
      Given There are minimal testing records

  Scenario: Guest can view vendros
    Given the following vendor exists:
    | name     |
    | 农工商超市 |
    When I go to the vendors page
    Then I should see "农工商超市"

  @focus
  Scenario: User can search for vendors
    Given the following vendor exists:
    | name     |
    | 农工商超市 |
    Given the following vendor exists:
    | name       | disabled |
    | 家乐福超市 | true   |
    When I go to the vendors page
    Then I should see "农工商超市"
    And I fill in "search" with "农工商超市"
    And I press "搜索"
    And I should not see "没有找到名为<家乐福超市>的商户"

    When I go to the vendors page
    Then I should not see "家乐福超市"
    And I fill in "search" with "家乐福超市"
    And I press "搜索"
    And I should see "没有找到名为<家乐福超市>的商户"

  @focus
  Scenario: User can create vendor if it didn't exist
    When I log in as "David User"
    And I go to the vendors page
    And I fill in "search" with "农工商超市"
    And I press "搜索"
    Then I should see "没有找到名为<农工商超市>的商户"
    When I follow "商户: <农工商超市>"
    And I press "完成"
    And I go to the vendors page
    And I fill in "search" with "农工商超市"
    And I press "搜索"
    Then I should not see "没有找到名为<农工商超市>的商户"

  Scenario: Quest can not create a vendor
    When I go to the new_vendor page
    Then I should be on the log_in page

  @focus
  Scenario: User can create a vendor from the index page
    When I log in as "David User"
    And I go to the vendors page
    Then I follow "新建商户"
    When I fill in "vendor_name" with "肯德基"
    And I fill in "vendor_address_attributes_detail" with "大华二路"
    And I press "完成"
    And I go to the vendors page
    Then I should see "肯德基"

  @focus
  Scenario: Only admin can edit vendor if it is not locked
    Given the following vendor exists:
    | name       |
    | 农工商超市 |
   Given the following vendor exists:
    | name       | disabled |
    | 家乐福超市 | true   |

    When I log in as "Ray Admin"
    And I go to the admin_vendors page
    And I follow "农工商超市"
    And I follow "编辑"
    Then I should see "编辑商户"

    When I go to the admin_vendors page
    And I follow "家乐福超市"
    And I follow "编辑"
    Then I should see "编辑商户"

  @focus
  Scenario: User can post error report for vendor's information
    Given the following vendor exists:
    | name       |
    | 农工商超市 |

    When I go to the vendors page
    And I fill in "search" with "农工商超市"
    And I press "搜索"
    And I follow "农工商超市"
    And I follow "信息有误/纠正"

  Scenario: User can upload images for vendor


  Scenario: Vendor can only be managed form the admin control panel
     Given the following vendor exists:
        | name       |
        | 农工商超市 |
     When I log in as "Ray Admin"
     And I go to the vendors page
     And I follow "农工商超市"
     Then I should not see "编辑"

  Scenario: Only Editor or Admin can lock a vendor
    Given the following vendor exists:
        | name       |
        | 农工商超市 |
        When I log in as "Ray Admin"
        And I go to the admin_vendors page
        And I follow "农工商超市"
        And I follow "编辑"
        And I check "vendor_disabled"

        And I press "完成"

        When I log in as "David User"
        And I go to the admin_vendors page
        Then I should be on the home page





