#encoding utf-8

require 'fileutils'

namespace :silver_sphinx do
  desc "Start a Sphinx searchd daemon using Silver Sphinx's settings"
  task :start => :environment do
    config = SilverSphinx::Configuration.instance

    FileUtils.mkdir_p config.searchd_file_path
    raise RuntimeError, "searchd is already running." if sphinx_running?

    Dir["#{config.searchd_file_path}/*.spl"].each { |file| File.delete(file) }

    config.controller.start

    if sphinx_running?
      puts "Started successfully (pid #{sphinx_pid})."
    else
      puts "Failed to start searchd daemon. Check #{config.searchd_log_file}"
    end
  end

  desc "Stop Sphinx using Silver Sphinx's settings"
  task :stop => :environment do
    unless sphinx_running?
      puts "searchd is not running"
    else
      config = SilverSphinx::Configuration.instance
      pid    = sphinx_pid
      config.controller.stop
      puts "Stopped search daemon (pid #{pid})."
    end
  end

  desc "Restart Sphinx"
  task :restart => [:environment, :stop, :start]

  desc "Generate the Sphinx configuration file using Silver Sphinx's settings"
  task :configure => :environment do
    config = SilverSphinx::Configuration.instance
    puts "Generating Configuration to #{config.config_file}"
    config.build
  end

  desc "Index data for Sphinx using Silver Sphinx's settings"
  task :index => :environment do
    config = SilverSphinx::Configuration.instance
    FileUtils.mkdir_p config.searchd_file_path
    config.controller.index :verbose => true
  end

  desc "Stop Sphinx (if it's running), rebuild the indexes, and start Sphinx"
  task :rebuild => :environment do
    Rake::Task["silver_sphinx:stop"].invoke if sphinx_running?
    Rake::Task["silver_sphinx:index"].invoke
    Rake::Task["silver_sphinx:start"].invoke
  end
end

def sphinx_pid
  SilverSphinx.sphinx_pid
end

def sphinx_running?
  SilverSphinx.sphinx_running?
end
