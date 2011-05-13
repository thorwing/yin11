module WikiHelper

  def categories_for_select
    WikiCategory.all.collect {|c|[ c.name, c.id ]}
  end

  # Creates a hyperlink to a Wiki page, or to a "new page" form if the page doesn't exist yet
  def link_to_page(page_name, web = @web, text = nil, options = {})
    raise 'Web not defined' if web.nil?
    UrlGenerator.new(@controller).make_link(@web, page_name, web, text,
        options.merge(:base_url => "#{base_url}/#{web.address}")).html_safe
  end

  def list_item(text, link_options, description, accesskey = nil)
    link_options[:controller] = 'wiki'
    link_to_unless_current(text, link_options, :title => description, :accesskey => accesskey) {
      content_tag('b', text, 'title' => description, 'class' => 'navOn')
    }
  end

end
