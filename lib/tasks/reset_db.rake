#encoding utf-8

namespace :yin11 do
  desc "db:drop then db:seed"
  task :reset => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:seed'].invoke
    puts "The database has been reset."
  end
end