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
  end

end