#encoding utf-8
namespace :yin11 do
  desc "send updates to users"
  #TODO
  #to schedule this task
  task :send_updates => :environment do
    User.enabled.active_users.each do |user|
      user.send_updates
    end
  end
end