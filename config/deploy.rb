set :application, "yinkuaizi.com"
role :web, application                          # Your HTTP server, Apache/etc
role :app, application                          # This may be the same as your `Web` server
role :db,  application, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :user, "root"
set :deploy_to, "/var/www/yin11"
set :deploy_via, :remote_cache
set :use_sudo, false
set :ssh_options, {:forward_agent => true}
#set :scm_user, 'thorwing'
#set :scm_passphrase, "XXX"  # The deploy user's password

set :scm, :git
set :repository,  "git@github.com:thorwing/yin11.git"
set :branch, "master"

set :rvm_type, :user

#set :mongodbname_prod, 'yin11_development'
#set :mongodbname_dev, 'yin11_production'

#Capistrano default behavior is to 'touch' all assets files.
#(To make sure that any cache get the deployment date). Assets are images, stylesheets, etc.
#To disable asset timestamps updates, simply add:
set :normalize_asset_timestamps, false

#after "deploy:update_code", "deploy:precompile_assets"
#desc "Compile all the assets named in config.assets.precompile."
#task :precompile_assets do
#  raise "Rails environment not set" unless rails_env
#  task = "assets:precompile"
#  run "cd #{release_path} && bundle exec rake #{task} RAILS_ENV=#{rails_env}"
#end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do
    run "/etc/init.d/nginx start"
   end
   task :stop do
    run "/etc/init.d/nginx stop"
   end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end