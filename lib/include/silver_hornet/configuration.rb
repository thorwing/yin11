class SilverHornet::Configuration
  #the sites that listed in the configuration file
  attr_accessor :sites

  def initialize(site_class_name, path)
    #the path to the config file
    @path = path
    #could be products_site or articles_site
    @site_class_name = site_class_name
  end

  def parse_config
    return unless (@path.present? && File.exists?(@path))

    #initialize the sites array
    self.sites ||= []
    #open the config file
    conf = YAML::load(ERB.new(IO.read(@path)).result)

    conf.each do |site_name, values|
      #instanize the site (products_site or articles_site)) object
      s = eval("#{@site_class_name}.new")
      s.name = site_name
      values.each do |key, value|
        #Set attributes according to the settings in the config file
        s.send("#{key}=", value) if s.respond_to?("#{key}=")
      end

      #put to array
      self.sites << s
    end
  end

end
