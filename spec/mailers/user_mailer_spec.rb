require 'spec_helper'

describe UserMailer do
  describe "password_reset" do
    let(:user) { Factory(:normal_user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "send user password reset url" do
      mail.subject.should eq(I18n.t("authentication.reset_password"))
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
end