module GeneralSteps
  def generate_testing_data
    Factory(:shanghai)
  end

  def login_as(user)
    visit login_path
    fill_in "email", :with => user.email
    fill_in "password", :with => user.password
    click_button I18n.t("authentication.login")
  end

  def search_for(query)
    visit root_path
    within("div#search_frame") do
      fill_in "query", :with => query
      click_button I18n.t("general.search")
    end
  end
end