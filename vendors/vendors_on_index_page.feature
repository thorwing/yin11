# encoding: UTF-8
Feature: products listed on index page
 �û����Է�����������ҳ
 �û����Լӹ�ע����

  Background:
      Given There are minimum seeds data

  Scenario: Guest can see all vendros
    Given the following vendor exists:
      | name       |
      | ũ���̳��� |
    When I go to the vendors page
    Then I should see "ũ���̳���"