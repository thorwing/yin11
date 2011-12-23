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

#set :output, "/home/ray/Development/Sites/yin11/log/cron_log.log"
#
#every 2.hours do
#  command "cd /home/ray/Development/Sites/yin11"
#  command "/usr/local/coreseek/bin/indexer -c /home/ray/Development/Sites/yin11/config/development.sphinx.conf --all --rotate"
#end


#***Production***

set :output, "/var/www/yin11/current/log/cron_log.log"

every 5.hours do
  command "/usr/local/coreseek/bin/indexer -c /var/www/yin11/current/config/production.sphinx.conf --all --rotate"
end