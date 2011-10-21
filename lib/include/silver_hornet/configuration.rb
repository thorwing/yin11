module SilverHornet
  class Configuration
    include Singleton

    attr_accessor :article_sites, :product_sites

    def parse_articles_config
      path = "#{Rails.root}/config/silver_hornet_articles.yml"
      return unless File.exists?(path)

      self.article_sites ||= []
      conf = YAML::load(ERB.new(IO.read(path)).result)

      conf.each do |site_name, values|
        s = Site.new(:name => site_name)
        values.each do |key, value|
          s.send("#{key}=", value) if s.respond_to?("#{key}=")
        end

        self.article_sites << s
      end
    end

  end
end