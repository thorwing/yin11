module ExternalLinkHelper
  def new_tab_link_to *args, &block
    if block_given?
      options = args.first || {}
      html_options = args[1] || {}

      if options.is_a? String
        if is_external_link? request.host, options
          html_options[:target] = '_BLANK'
          html_options[:rel] = 'nofollow'
        end
      end

      link_to options, html_options, &block
    else
      name = args.first
      options = args[1] || {}
      html_options = args[2] || {rel: 'nofollow'}

      if options.is_a? String
        if is_external_link? request.host, options
          html_options[:target] = '_BLANK'
          html_options[:rel] = 'nofollow'
        end
      end

      link_to name, options, html_options
    end
  end

  def is_external_link? host, url
    host.sub! /^www\./, ''
    url =~ /^http/i && url !~ /^http:\/\/(www\.)?#{host}/i
  end
end
