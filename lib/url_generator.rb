class AbstractUrlGenerator

  def initialize(controller)
    raise 'Controller cannot be nil' if controller.nil?
    @controller = controller
  end

  # Create a link for the given page (or file) name and link text based
  # on the render mode in options and whether the page (file) exists
  # in the web.
  def make_link(current_web, asked_name, web, text = nil, options = {})
    @web = current_web
    mode = (options[:mode] || :show).to_sym
    link_type = (options[:link_type] || :show).to_sym

    if (link_type == :show)
      page_exists = web.has_page?(asked_name)
      known_page = page_exists || web.has_redirect_for?(asked_name)
      if known_page && !page_exists
        name = web.page_that_redirects_for(asked_name).name
      else
        name = asked_name
      end
    else
      name = asked_name
      known_page = web.has_file?(name)
      description = web.description(name)
      description = description.unescapeHTML.escapeHTML if description
    end
    if (text == asked_name)
      text = description || text
    else
      text = text || description
    end
    text = (text || WikiWords.separate(asked_name)).unescapeHTML.escapeHTML
    
    case link_type
    when :show
      page_link(mode, name, text, web.address, known_page)
    when :file
      file_link(mode, name, text, web.address, known_page, description)
    when :pic
      pic_link(mode, name, text, web.address, known_page)
    when :audio
      media_link(mode, name, text, web.address, known_page, 'audio')
    when :video
      media_link(mode, name, text, web.address, known_page, 'video')
    when :delete
      delete_link(mode, name, web.address, known_page)
    else
      raise "Unknown link type: #{link_type}"
    end
  end

  def url_for(hash = {})
    @controller.url_for hash
  end  
end

class UrlGenerator < AbstractUrlGenerator

end