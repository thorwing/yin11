#some generic steps
Then /^I should see "(.+)" whose id is "(.+)"$/ do |element_type, id|
  page.has_xpath?("//#{element_type}[@id='#{id}']")
end

Then /^I should not see "(.+)" whose id is "(.+)"$/ do |element_type, id|
  page.has_no_xpath?("//#{element_type}[@id='#{id}']")
end

Then /^I should see "(.+)" whose "(.+)" is "(.+)"$/ do |element_type, attr, value|
  page.has_xpath?("//#{element_type}[@#{attr}='#{value}']")
end

Then /^I should not see "(.+)" whose "(.+)" is "(.+)"$/ do |element_type, attr, value|
  page.has_no_xpath?("//#{element_type}[@#{attr}='#{value}']")
end

Then /^(?:|I )should not be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should_not == path_to(page_name)
  else
    assert_not_equal path_to(page_name), current_path
  end
end

Then /^I should see the following elements:$/ do |table|
  table.raw.each do |row|
    page.should have_css(row.first)
  end
end

When /^I upload a file "(.+)" to "(.+)"$/ do |file_name, field|
  attach_file(field, File.join(Rails.root, "features", file_name))
end