require 'spec_helper'

describe "Activation" do
  describe "valid user" do
    it "emails user after sign up" do
      user = User.new(:email => "mailing@yin11.com", :login_name => "mailman", :password => "123456")
      user.should be_valid
      sign_up(user)
      current_path.should eq(users_path)
      page.should have_content(I18n.t("notices.activation_required"))
      last_email.to.should include(user.email)

      login_as(user)

      page.should have_content(I18n.t("notices.activation_required"))
    end
  end

  describe "a user with same email already exists" do
    let(:user) {Factory(:normal_user)}

    it "does not email if sign up failed" do
      sign_up(user)
      page.should_not have_content(I18n.t("notices.activation_email_sent"))
      last_email.should be_nil
    end
  end

  describe "inactive user" do
    it "unactivated user can visit profile page" do
      user = User.new(:email => "mailing@yin11.com", :login_name => "mailman", :password => "123456")
      sign_up(user)
      login_as(user)
      within "#top_menu" do
        page.should have_content(I18n.t("menu.show_profile"))
        click_link I18n.t("menu.show_profile")
      end
      page.should have_content(I18n.t("profile.show_profile"))
    end
  end

  it "unactivated user can't do anything else" do
    user = User.new(:email => "mailing@yin11.com", :login_name => "mailman", :password => "123456")
    sign_up(user)

    login_as(user)
    visit new_review_path
    current_path.should eq(root_path)
    page.should have_content(I18n.t("notices.activation_required"))
  end


  it "activate the user if token matches" do
    user = Factory(:normal_user, :activation_token => "something")
    visit activate_user_path(user.activation_token)
    page.should have_content(I18n.t("notices.user_activated"))
    current_path.should eq(login_path)
    login_as(user)
    visit new_review_path
    current_path.should eq(new_review_path)
  end

  it "raises record not found when password token is invalid" do
    lambda {
      visit activate_users_path("invalid")
    }.should raise_exception()
  end
end
