#encoding utf-8
namespace :yin11 do
  desc "flush cache"
  #TODO
  #to schedule this task
  task :flush_cache => :environment do
    CacheManager.flush_cache
  end
end