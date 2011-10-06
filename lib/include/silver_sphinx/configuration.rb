require 'erb'
require 'singleton'

module SilverSphinx
  class Configuration
    include Singleton

    SourceOptions = %w( mysql_connect_flags mysql_ssl_cert mysql_ssl_key
      mysql_ssl_ca sql_range_step sql_query_pre sql_query_post
      sql_query_killlist sql_ranged_throttle sql_query_post_index unpack_zlib
      unpack_mysqlcompress unpack_mysqlcompress_maxsize )

    IndexOptions  = %w( blend_chars charset_table charset_type charset_dictpath
      docinfo enable_star exceptions expand_keywords hitless_words
      html_index_attrs html_remove_elements html_strip index_exact_words
      ignore_chars inplace_docinfo_gap inplace_enable inplace_hit_gap
      inplace_reloc_factor inplace_write_factor min_infix_len min_prefix_len
      min_stemming_len min_word_len mlock morphology ngram_chars ngram_len
      ondisk_dict overshort_step phrase_boundary phrase_boundary_step preopen
      stopwords stopwords_step wordforms )

    attr_accessor :searchd_file_path, :model_directories, :indexed_models
    attr_accessor :source_options, :index_options
    attr_accessor :configuration, :controller

    def initialize
      init_root_env
      @configuration = Riddle::Configuration.new
      @configuration.searchd.pid_file   = "#{@root}/log/searchd.#{@env}.pid"
      @configuration.searchd.log        = "#{@root}/log/searchd.log"
      @configuration.searchd.query_log  = "#{@root}/log/searchd.query.log"

      @controller = Riddle::Controller.new @configuration, "#{@root}/config/#{@env}.sphinx.conf"

      self.address              = "127.0.0.1"
      self.port                 = 9312
      self.searchd_file_path    = "#{@root}/db/sphinx/#{@env}"
      self.model_directories    = ["#{@root}/app/models/"] + Dir.glob("#{@root}/vendor/plugins/*/app/models/")
      self.indexed_models       = []

      self.source_options  = {
        :type => "xmlpipe2"
      }
      self.index_options   = {
        :docinfo => "extern",
        :mlock => 0,
        :morphology => "none",
        :html_strip => 0,
        :charset_type => "zh_cn.utf-8",
        :ngram_len => 0,
      }

      parse_config

      self
    end

    def client
      @configuration ||= parse_config
      Riddle::Client.new address, port
    end

    def build(file_path=nil)
      file_path ||= "#{self.config_file}"

      @configuration.indexes.clear

      SilverSphinx.context.indexed_models.each do |model|
        model = model.constantize
        @configuration.indexes.concat model.to_riddle
      end

      open(file_path, "w") do |file|
        file.write @configuration.render
      end
    end

    def address
      @address
    end

    def address=(address)
      @address = address
      @configuration.searchd.address = address
    end

    def port
      @port
    end

    def port=(port)
      @port = port
      @configuration.searchd.port = port
    end

    def mem_limit
      @mem_limit
    end

    def mem_limit=(mem_limit)
      @mem_limit = mem_limit
      @configuration.indexer.mem_limit = mem_limit
    end

    def pid_file
      @configuration.searchd.pid_file
    end

    def pid_file=(pid_file)
      @configuration.searchd.pid_file = pid_file
    end

    def searchd_log_file
      @configuration.searchd.log
    end

    def searchd_log_file=(file)
      @configuration.searchd.log = file
    end

    def query_log_file
      @configuration.searchd.query_log
    end

    def query_log_file=(file)
      @configuration.searchd.query_log = file
    end

    def config_file
      @controller.path
    end

    def config_file=(file)
      @controller.path = file
    end

    def bin_path
      @controller.bin_path
    end

    def bin_path=(path)
      @controller.bin_path = path
    end

    def searchd_binary_name
      @controller.searchd_binary_name
    end

    def searchd_binary_name=(name)
      @controller.searchd_binary_name = name
    end

    def indexer_binary_name
      @controller.indexer_binary_name
    end

    def indexer_binary_name=(name)
      @controller.indexer_binary_name = name
    end

    private

    def parse_config
      path = "#{@root}/config/sphinx.yml"
      return unless File.exists?(path)

      conf = YAML::load(ERB.new(IO.read(path)).result)[@env]

      conf.each do |key,value|
        if IndexOptions.include?(key.to_s)
          self.index_options[key.to_sym] = value
        else
          self.send("#{key}=", value) if self.respond_to?("#{key}=")
        end
      end
    end

    def init_root_env
      if defined?(Rails)
        @root = Rails.root
        @env = Rails.env
      else
        @root = Dir.pwd
        @env = ENV['RACK_ENV'] || 'development'
      end
    end

  end
end
