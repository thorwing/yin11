require 'spec_helper'

describe UserMailer do
  describe "password_reset" do
    let(:user) { Factory(:normal_user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "send user password reset url" do
      mail.subject.should eq(I18n.t("mailers.reset_password_subject"))
      mail.to.should eq([user.email])
      mail.from.should eq(["yin11.mailer@gmail.com"])
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end

  describe "email_verification" do
    let(:user) { Factory(:normal_user, :email_verification_token => "anything") }
    let(:mail) { UserMailer.email_verify(user) }

    it "send email_verify url" do
      mail.subject.should eq(I18n.t("mailers.verify_email_subject"))
      mail.to.should eq([user.email])
      mail.from.should eq(["yin11.mailer@gmail.com"])
      mail.body.encoded.should match(verify_email_path(user.email_verification_token))
    end
  end

  describe "updates" do
    before { @items = [ Factory(:bad_review, :tags_string => "milk")] }
    let(:user) { Factory(:normal_user) }
    let(:mail) { UserMailer.updates(user, user.get_updates) }

    it "send updates url" do
      user.profile.watched_tags = ["milk"]
      user.profile.save!
      mail.subject.should eq(I18n.t("mailers.updates_subject"))
      mail.to.should eq([user.email])
      mail.from.should eq(["yin11.mailer@gmail.com"])
      @items.each do |item|
        mail.body.encoded.should match(url_for(item))
      end
    end
  end

end