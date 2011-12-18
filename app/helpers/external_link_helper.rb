module ExternalLinkHelper
  def new_tab_link_to *args, &block
    #p "here args"
    #p "args: " + args.join("::")

    if block_given?
      options = args.first || {}
      html_options = args[1] || {}

      if options.is_a? String
        if (is_external_link? request.host, options) ||  (options[:force] == "true")
          html_options[:target] = '_BLANK'
          html_options[:rel] = 'nofollow'
        end
      end

      link_to options, html_options, &block

    else
      name = args.first
      options = args[1] || {}
      html_options = args[2] || {rel: 'nofollow'}

      #p "html_options_old: " + html_options.to_yaml

      if options.is_a? String
        if (is_external_link? request.host, options)
        # ||  ((options.is_a? Hash) && (options[:force].present?) && (options[:force] == "true"))
          html_options[:target] = '_BLANK'
          html_options[:rel] = 'nofollow'
        end
      else if options.is_a? Hash
             if (is_external_link? request.host, options) || (options[:force] == "true")
                html_options[:target] = '_BLANK'
                html_options[:rel] = 'nofollow'
             end
           end
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
