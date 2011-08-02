#encoding utf-8
namespace :yin11 do
  desc "send updates mail to users"
  #TODO
  #to schedule this task
  task :mail_updates => :environment do
    User.send_updates_to_users
  end
end