module SilverSphinxModel
  extend ActiveSupport::Concern
  included do
    unless defined?(SPHINX_TYPE_MAPPING)
      SPHINX_TYPE_MAPPING = {
        'Date' => 'timestamp',
        'DateTime' => 'timestamp',
        'Time' => 'timestamp',
        'Float' => 'float',
        'Integer' => 'int',
        'BigDecimal' => 'float',
        'Boolean' => 'bool'
      }
    end

    cattr_accessor :search_fields
    cattr_accessor :search_attributes
    cattr_accessor :index_options
  end

  module ClassMethods

    def search_index(options={})
      self.search_fields = options[:fields]
      self.search_attributes = {}
      self.index_options = options[:options] || {}
      attribute_types = options[:attribute_types] || {}
      options[:attributes].each do |attrib|
        attr_type = attribute_types[attrib].to_s || self.fields[attrib.to_s].type.to_s
        self.search_attributes[attrib] = SPHINX_TYPE_MAPPING[attr_type] || 'str2ordinal'
      end
      SilverSphinx.context.add_indexed_model self
    end

    def generate_id(object_id)
      @@exist_ids ||= []
      id = object_id.to_s[0,8].hex
      while true
        if @@exist_ids.include? id
          id += 1
        else
          break
        end
      end
      @@exist_ids << id
      return id
    end

    def internal_sphinx_index
      SilverSphinx::Index.new(self)
    end

    def has_sphinx_indexes?
      self.search_fields && self.search_fields.length > 0
    end

    def to_riddle
      self.internal_sphinx_index.to_riddle
    end

    def sphinx_stream
      STDOUT.sync = true # Make sure we really stream..

      puts '<?xml version="1.0" encoding="utf-8"?>'
      puts '<sphinx:docset>'

      # Schema
      puts '<sphinx:schema>'
      puts '<sphinx:field name="classname"/>'
      self.search_fields.each do |name|
        puts "<sphinx:field name=\"#{name}\"/>"
      end
      puts "<sphinx:attr name=\"_id\" type=\"string\" />"
      self.search_attributes.each do |key, value|
        puts "<sphinx:attr name=\"#{key}\" type=\"#{value}\"/>"
      end
      puts '</sphinx:schema>'

      self.all.each do |document|
        sphinx_compatible_id = self.generate_id(document['_id'])
        puts "<sphinx:document id=\"#{sphinx_compatible_id}\">"

        puts "<classname>#{self.to_s}</classname>"
        self.search_fields.each do |key|
          if document.respond_to?(key.to_sym)
            puts "<#{key}>#{REXML::Text.new( document.send(key).to_s ).to_s}</#{key}>"
          end
        end
        puts "<_id>#{document.send("_id")}</_id>"
        self.search_attributes.each do |key, value|
          value = case value
            when 'bool'
              document.send(key) ? 1 : 0
            when 'timestamp'
              document.send(key).to_i
            else
              document.send(key)
          end
          puts "<#{key}>#{REXML::Text.new( document.send(key).to_s).to_s}</#{key}>"
        end

        puts '</sphinx:document>'
      end

      puts '</sphinx:docset>'
    end

    def search(query, options = {})
      client = SilverSphinx::Configuration.instance.client

      client.match_mode = options[:match_mode] || :extended
      client.offset = options[:offset].to_i if options.key?(:offset)
      client.limit = options[:limit].to_i if options.key?(:limit)
      client.limit = options[:per_page].to_i if options.key?(:per_page)
      client.offset = (options[:page].to_i - 1) * client.limit if options[:page]
      client.max_matches = options[:max_matches].to_i if options.key?(:max_matches)
      client.set_anchor(*options[:geo_anchor]) if options.key?(:geo_anchor)

      if options.key?(:sort_by)
        client.sort_mode = :extended
        client.sort_by = options[:sort_by]
      end

      if options.key?(:with)
        options[:with].each do |key, value|
          client.filters << Riddle::Client::Filter.new(key.to_s, value.is_a?(Range) ? value : value.to_a, false)
        end
      end

      if options.key?(:without)
        options[:without].each do |key, value|
          client.filters << Riddle::Client::Filter.new(key.to_s, value.is_a?(Range) ? value : value.to_a, true)
        end
      end

      result = client.query("#{query} @classname #{self.to_s}")
      SilverSphinx::Search.new(client, self, result)
    end
  end

end
