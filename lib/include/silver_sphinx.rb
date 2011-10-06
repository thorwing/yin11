require "mongoid"
require "riddle"
require "riddle/1.10"

require 'silver_sphinx/configuration'
require 'silver_sphinx/context'
require 'silver_sphinx/index'
require 'silver_sphinx/search'

module SilverSphinx

  @@sphinx_mutex = Mutex.new
  @@context      = nil

  def self.context
    if @@context.nil?
      @@sphinx_mutex.synchronize do
        if @@context.nil?
          @@context = SilverSphinx::Context.new
          @@context.prepare
        end
      end
    end

    @@context
  end

  def self.reset_context!
    @@sphinx_mutex.synchronize do
      @@context = nil
    end
  end

  def self.pid_active?(pid)
    !!Process.kill(0, pid.to_i)
  rescue Errno::EPERM => e
    true
  rescue Exception => e
    false
  end

  def self.sphinx_running?
    !!sphinx_pid && pid_active?(sphinx_pid)
  end

  def self.sphinx_pid
    if File.exists?(SilverSphinx::Configuration.instance.pid_file)
      File.read(SilverSphinx::Configuration.instance.pid_file)[/\d+/]
    else
      nil
    end
  end

end
