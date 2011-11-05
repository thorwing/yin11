Feature: login logic
  访客可以访问主页
  用户可以从主页上直接登录
  用户可以从主页过渡到登录页进行登录
  用户可以选择“记住我”，从而在下一次访问时不用再登录
  已登录用户可以“登出”
  已登录用户可以重设密码
  未登录用户可以通过“忘记密码？”链接来重设密码
  已登录用户将不会在主页上看到指向登录页面的链接
  未登录用户在主页和其他页上会看到登录的链接
  如果未登录用户访问无权的网页，会看到提示登录/注册的信息

  Background:
    Given There are minimum seeds data

  Scenario: 访客可以访问主页
      When I go to the home page
      And I should be on the home page
