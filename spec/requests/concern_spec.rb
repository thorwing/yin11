require 'spec_helper'

describe "Concern" do
  let(:user) {Factory(:normal_user)}
  before {
    @vendor = Factory(:vendor, :name => "big supermarket", :city => "shanghai", :street => "nanjing road" )
    @review = Factory(:review, :vendor_id => @vendor.id, :tags_string => "milk")
    @tip = Factory(:tip)
  }

  it "control panel gets displayed" do
    login_as(user)
    visit root_path
    page.should have_content I18n.t("control_panel.tags")
    page.should have_content I18n.t("control_panel.locations")
    page.should have_content I18n.t("control_panel.tips")
    page.should have_content I18n.t("control_panel.groups")
  end

  it "watched tags got displayed" do
    user.profile.watch_tags!("milk")
    login_as(user)
    visit root_path
    within "#control_panel" do
      page.should have_content "milk"
      page.should have_content I18n.t("severity.severity_1")
      click_link "milk"
    end
    page.should have_content @review.title
  end

  it "collected_tips get displayed" do
    user.profile.collect_tip!(@tip)
    user.profile.collected_tip_ids.should include(@tip.id)
    login_as(user)
    visit root_path
    within "#control_panel" do
      page.should have_content @tip.title
      click_link @tip.title
    end
    page.should have_content @tip.content
  end

  #TODO
  #2d index
  #it "watched_locations get displayed" do
  #  location = user.profile.watched_locations.new(:city => "shanghai", :street => "nanjing road")
  #  location.save!
  #
  #  login_as(user)
  #  visit root_path
  #  within "#control_panel" do
  #    page.should have_content location.address
  #    page.should have_content I18n.t("severity.severity_1")
  #    click_link location.address
  #  end
  #  page.should have_content @review.title
  #end

end

