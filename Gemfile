source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

#temp workaround, rake 0.9.0(and 0.9.1?) caused a problem on Heroku
gem "rake", "~> 0.8.7"

gem "mongoid", "~> 2.0.2"
gem "bson_ext", "~> 1.3"

gem "bcrypt-ruby", :require => "bcrypt"
#gem "bcrypt-ruby"

#gem "nokogiri"

gem "mongoid-ancestry"

#gem "tiny_mce"
#gem 'ckeditor-rails'

#no such file to load -- carrierwave/storage/grid_fs issue
gem 'carrierwave', '0.5.6'

gem 'kaminari'

#factory_girl is also used for db seeds
gem 'factory_girl_rails'

gem "geocoder"
gem "gmaps4rails"

gem "mechanize"
gem "spreadsheet"

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
    gem 'rspec-rails'
    gem 'cucumber'
    gem 'cucumber-rails'
    gem 'capybara'
    gem 'launchy'
    gem 'spork', "~> 0.9.0.rc9"

    gem 'guard-rspec'
    gem 'guard-cucumber'
    #for using guard on windows
    gem 'rb-fchange'
    gem 'rb-notifu'

    gem "escape_utils"
end

gem 'simplecov', '>= 0.4.0', :require => false, :group => :test
gem "nifty-generators", :group => :development
