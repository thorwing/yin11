class SilverHornet::Site
  #agent is the instance of the Mechanize, doc represents the html source of a internet page
  attr_accessor :agent, :doc
  #name of the site, count is the number of total items fetched from the site.
  attr_accessor :name, :count
  #these attributes' values will be directly set from configuration file
  attr_accessor :entries, :skipped, :elements

  def initialize(options={})
    options.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?("#{key}=")
    end
    self.count = 0
    #initiazlie the agent instance, it will be used through this site
    #self.agent = Mechanize.new
  end

  def log(msg)
    #print the message to the console
    p msg
    #record the message to the log file
    Rails.logger.info msg
  end

  #call the given block, handle the exception
  def try(&block)
    begin
      yield
    rescue Errno::ETIMEDOUT, Timeout::Error, Net::HTTPNotFound
      log "Connection Error"
    rescue Exception => exc
      log exc.message
      log exc.backtrace
    end
  end
end
