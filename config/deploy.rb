load 'deploy/assets'

set :application, "yinkuaizi.com"
set :repository,  "git@github.com:thorwing/yin11.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_via, :remote_cache

set :user, "root"
set :use_sudo, false
#set :mongodbname_prod, 'yin11_development'
#set :mongodbname_dev, 'yin11_production'

role :web, "#{application}"                          # Your HTTP server, Apache/etc
role :app, "#{application}"                          # This may be the same as your `Web` server
role :db,  "#{application}", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :deploy_to, "/var/www/yin11"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

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