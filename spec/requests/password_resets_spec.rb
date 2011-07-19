require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = Factory(:normal_user)
    visit login_path
    click_link "/password_resets/new"
    fill_in "Email", :with => user.email
    click_button t("authentication.reset_password")
    current_path.should eq(root_path)
    page.should have_content("Email sent")
    last_email.to.should include(user.email)
  end

  it "does not email invalid user when requesting password reset" do
    visit login_path
    click_link I18n.t("authentication.forgot_password")
    fill_in "Email", :with => "nobody@example.com"
    click_button I18n.t("authentication.reset_password")
    current_path.should eq(root_path)
    page.should have_content(I18n.t("notices.password_reset_email_sent"))
    last_email.should be_nil
  end

  it "updates the user password when confirmation matches" do
    user = Factory(:user, :password_reset_token => "something", :password_reset_sent_at => 1.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "Password", :with => "foobar"
    click_button I18n.t("authentication.update_password")
    page.should have_content(t("authentication.pwd_confirmation_not_match"))
    fill_in "Password", :with => "foobar"
    fill_in "Password confirmation", :with => "foobar"
    click_button I18n.t("authentication.update_password")
    page.should have_content(I18n.t("notices.password_reset"))
  end

  it "reports when password token has expired" do
    user = Factory(:user, :password_reset_token => "something", :password_reset_sent_at => 5.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "Password", :with => "foobar"
    fill_in "Password confirmation", :with => "foobar"
    click_button I18n.t("authentication.update_password")
    page.should have_content(I18n.t("alerts.password_reset_expired"))
  end

  it "raises record not found when password token is invalid" do
    lambda {
      visit edit_password_reset_path("invalid")
    }.should raise_exception()
  end
end
