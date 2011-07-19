require "factory_girl/step_definitions"

After do |scenario|
  #page.driver.browser.switch_to.alert.dismiss
  # or accept it if that is what you prefer
  # page.driver.browser.switch_to.alert.accept

  puts "cleaning mongodb...."
  Mongoid.database.collections.each do |collection|
    unless collection.name =~ /^system\./
      collection.remove
    end
  end
  puts "finished cleaning mongodb after \"#{scenario.name}\"."
end

#require 'cucumber/rails/rspec'
#require 'cucumber/rails/world'
#require 'cucumber/web/tableish'
#require 'mongoid'
#
#
#require 'capybara/rails'
#require 'capybara/cucumber'
#require 'capybara/session'
#
#ENV["RAILS_ENV"] ||= "test"
#require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

