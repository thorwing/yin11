class Wiki

  def self.load_page(title)
    page = WikiPage.first(conditions: { title: title })
    page
  end

end
