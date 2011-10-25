class SilverHornet::Site
  attr_accessor :agent
  attr_accessor :name, :entries, :skipped, :elements, :count

  def initialize(options={})
    options.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?("#{key}=")
    end
    self.count = 0
    self.agent = Mechanize.new
  end

  def log(msg)
    p msg
    Rails.logger.info msg
  end
end