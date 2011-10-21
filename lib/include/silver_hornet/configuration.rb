class SilverHornet::Configuration
  attr_accessor :sites

  def initialize(site_class_name, path)
    @path = path
    @site_class_name = site_class_name
  end

  def parse_config
    return unless (@path.present? && File.exists?(@path))

    self.sites ||= []
    conf = YAML::load(ERB.new(IO.read(@path)).result)

    conf.each do |site_name, values|
      s = eval("#{@site_class_name}.new")
      s.name = site_name
      values.each do |key, value|
        s.send("#{key}=", value) if s.respond_to?("#{key}=")
      end

      self.sites << s
    end
  end

end
