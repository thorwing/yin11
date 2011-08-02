require 'spec_helper'

describe "Updates" do
  let(:user) {Factory(:normal_user)}

  describe "there are some updates for the users" do
    before { @items = [ Factory(:bad_review, :tags_string => "milk")] }
    it "should have updates" do
      user.profile.watched_tags = ["milk"]
      user.profile.save!
      user.send_updates
      last_email.to.should include(user.email)
      @items.each do |item|
        last_email.body.encoded.should match(url_for(:controller => "#{item.class.name.downcase.pluralize}", :action => "show", :id => item.id , :host => "localhost:3000", :only_path => false))
      end
    end

    it "email_receivers will receive email" do
      User.send_updates_to_users
      last_email.to.should include(user.email)
    end

    it "non_email_receiver will not receive email" do
      user.profile.receive_mails = false
      user.profile.save!

      User.send_updates_to_users
      last_email.to.should_not include(user.email)
    end
  end



end