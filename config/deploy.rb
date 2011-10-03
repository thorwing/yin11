load 'deploy/assets'
set :application, "yinkuaizi.com"
role :web, application                          # Your HTTP server, Apache/etc
role :app, application                          # This may be the same as your `Web` server
role :db,  application, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :user, "root"
set :deploy_to, "/var/www/yin11"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository,  "git@github.com:thorwing/yin11.git"
set :branch, "master"

#set :mongodbname_prod, 'yin11_development'
#set :mongodbname_dev, 'yin11_production'

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