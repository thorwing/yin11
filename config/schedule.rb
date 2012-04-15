# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#***Development***
#PATH=/sbin:/bin:/usr/sbin:/usr/bin:/home/ray/.rvm/bin:/home/ray/.rvm/gems/ruby-1.9.2-p290/bin
#SHELL=/home/ray/.rvm/bin/rvm-shell
#RAILS_ENV=development

#set :output, "/home/ray/Development/Sites/yin11/log/cron_log.log"
#
#every 1.minutes do
#  #command "source /home/ray/.rvm/environments/ruby-1.9.2-p290"
#  #rake "yin11:clean_images"
#  command "cd /home/ray/Development/Sites/yin11 && /usr/local/coreseek/bin/indexer -c /home/ray/Development/Sites/yin11/config/development.sphinx.conf --all --rotate"
#end


#***Production***
#PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/rvm/rubies/ruby-1.9.2-p290/bin/ruby:/usr/local/rvm/gems/ruby-1.9.2-p290/bin
##SHELL=/user/local/rvm/bin/rvm-shell
##RAILS_ENV=production

# 0 * * * * /bin/bash -l -c 'cd /var/www/yin11/current && /usr/local/coreseek/bin/indexer -c /var/www/yin11/current/config/production.sphinx.conf --all --rotate >> /var/www/yin11/current/log/cron_log.log 2>&1'

set :output, "/var/www/yin11/current/log/cron_log.log"

every 1.hours do
  command "cd /var/www/yin11/current && /usr/local/coreseek/bin/indexer -c /var/www/yin11/current/config/production.sphinx.conf --all --rotate"
end