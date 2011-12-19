module ExternalLinkHelper
  def new_tab_link_to *args, &block
    @external = false

    if block_given?
      options = args.first || {}
      html_options = args[1] || {}

      if options.is_a? String
        if (is_external_link? request.host, options)
          @external = true
        end
      end

      link_to options, html_options, &block

    else
      name = args.first
      options = args[1] || {}
      html_options = args[2] || {rel: 'nofollow'}

      if options.is_a? String
        if (is_external_link? request.host, options)
          @external = true
        end
      else if options.is_a? Hash
         if (is_external_link? request.host, options) || (options[:force] == "true")
            @external = true
         end
      end
    end

    if @external
      html_options[:target] = '_BLANK'
      html_options[:rel] = 'nofollow'
    end

      #p "name" + name
      #p "options class: "+ options.class.name
      #p "options: "+ options.to_yaml
      #if (options.is_a? Hash) && (options[:force].present?)
      #  p "options[:force]: " + options[:force]
      #end
      #debug options
      #p "html_options_new: " + html_options.to_yaml

      link_to name, options, html_options
    end
  end

  def is_external_link? host, url
    host.sub! /^www\./, ''
    url =~ /^http/i && url !~ /^http:\/\/(www\.)?#{host}/i
  end
end
