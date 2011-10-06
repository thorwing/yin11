module SilverSphinx
  class Index
    attr_accessor :name, :model, :source

    def initialize(model)
      @name         = self.class.name_for model
      @model        = model
      @options      = model.index_options
      @source       = Riddle::Configuration::XMLSource.new( "#{core_name}_0", config.source_options[:type])
      if defined?(Rails)
        @source.xmlpipe_command = "RAILS_ENV=#{Rails.env} rails runner '#{model.to_s}.sphinx_stream'"
      else
        @source.xmlpipe_command = "script/runner '#{model.to_s}.sphinx_stream'"
      end
    end

    def core_name
      "#{name}_core"
    end

    def self.name_for(model)
      model.name.underscore.tr(':/\\', '_')
    end

    def local_options
      @options
    end

    def options
      all_index_options = config.index_options.clone
      @options.keys.select { |key|
        SilverSphinx::Configuration::IndexOptions.include?(key.to_s)
      }.each { |key| all_index_options[key.to_sym] = @options[key] }
      all_index_options
    end

    def to_riddle
      indexes = [to_riddle_for_core]
      indexes << to_riddle_for_distributed
    end

    private

    def utf8?
      options[:charset_type] == "utf-8"
    end

    def config
      @config ||= SilverSphinx::Configuration.instance
    end

    def to_riddle_for_core
      index = Riddle::Configuration::Index.new core_name
      index.path = File.join config.searchd_file_path, index.name

      set_configuration_options_for_indexes index
      index.sources << @source

      index
    end

    def to_riddle_for_distributed
      index = Riddle::Configuration::DistributedIndex.new name
      index.local_indexes << core_name
      index
    end

    def set_configuration_options_for_indexes(index)
      config.index_options.each do |key, value|
        method = "#{key}=".to_sym
        index.send(method, value) if index.respond_to?(method)
      end

      options.each do |key, value|
        index.send("#{key}=".to_sym, value) if SilverSphinx::Configuration::IndexOptions.include?(key.to_s) && !value.nil?
      end
    end
  end
end
