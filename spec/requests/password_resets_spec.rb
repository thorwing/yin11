require 'spec_helper'

describe "PasswordResets" do
  describe "normal user" do
    let(:user){ Factory(:normal_user) }

    it "emails user when requesting password reset" do
      visit login_path
      click_link I18n.t("authentication.forgot_password")
      within "#password_reset_form" do
        fill_in "email", :with => user.email
        click_button I18n.t("authentication.reset_password")
      end
      current_path.should eq(root_path)
      page.should have_content(I18n.t("notices.password_reset_email_sent"))

      last_email.to.should include(user.email)
    end

    it "does not email invalid user when requesting password reset" do
      visit login_path
      click_link I18n.t("authentication.forgot_password")
      within "#password_reset_form" do
        fill_in "email", :with => "nobody@example.com"
        click_button I18n.t("authentication.reset_password")
      end
      current_path.should eq(root_path)
      #do not let bad guys guess...
      page.should have_content(I18n.t("notices.password_reset_email_sent"))
      last_email.should be_nil
    end
  end

  it "updates the user password when confirmation matches" do
    user = Factory(:normal_user, :password_reset_token => "something", :password_reset_sent_at => 1.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "user_password", :with => "foobar"
    click_button I18n.t("authentication.update_password")
    page.should have_content(I18n.t("errors.messages.confirmation"))
    fill_in "user_password", :with => "foobar"
    fill_in "user_password_confirmation", :with => "foobar"
    click_button I18n.t("authentication.update_password")
    page.should have_content(I18n.t("notices.password_reset"))
  end

  it "reports when password token has expired" do
    user = Factory(:normal_user, :password_reset_token => "something", :password_reset_sent_at => 5.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "user_password", :with => "foobar"
    fill_in "user_password_confirmation", :with => "foobar"
    click_button I18n.t("authentication.update_password")
    page.should have_content(I18n.t("alerts.password_reset_expired"))
  end

  it "raises record not found when password token is invalid" do
    lambda {
      visit edit_password_reset_path("invalid")
    }.should raise_exception()
  end
end
