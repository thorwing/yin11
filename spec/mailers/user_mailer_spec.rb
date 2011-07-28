require 'spec_helper'

describe UserMailer do
  describe "password_reset" do
    let(:user) { Factory(:normal_user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "send user password reset url" do
      mail.subject.should eq(I18n.t("mailers.reset_password_subject"))
      mail.to.should eq([user.email])
      mail.from.should eq(["staff@yin11.com"])
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end

  describe "activation" do
    let(:user) { Factory(:normal_user, :activation_token => "anything") }
    let(:mail) { UserMailer.activation(user) }

    it "send activation url" do
      mail.subject.should eq(I18n.t("mailers.activation_subject"))
      mail.to.should eq([user.email])
      mail.from.should eq(["staff@yin11.com"])
      mail.body.encoded.should match(activate_user_path(user.activation_token))
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
      mail.from.should eq(["staff@yin11.com"])
      @items.each do |item|
        mail.body.encoded.should match(url_for(item))
      end
    end
  end

end