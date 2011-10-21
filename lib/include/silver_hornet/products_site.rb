class SilverHornet::ProductsSite < SilverHornet::Site

  def fetch
    if skipped.present? && skipped == true
      log "#{name} is skipped"
      return
    end

    agent = Mechanize.new
    begin
      self.entries.each do |entry_url|
        next_link = nil
        begin
          next_link.nil? ? agent.get(entry_url) : agent.click(next_link)
          start_url = agent.page.uri

          process_page(agent)

          #go back to the entry page
          agent.get(start_url)
          next_link = agent.page.at(elements["next_link"])

          log "Got #{count.to_s} products on #{name}: #{agent.page.uri.to_s}"
        end while next_link
      end
    rescue Exception => exc
      log exc.message
      log exc.backtrace
    end
  end

  def process_page(agent)
    log "Now dealing with #{name}: #{agent.page.uri.to_s}, see #{agent.page.search("#{elements["listed_product"]} a").size.to_s} products."
    agent.page.search(elements["listed_product"]).each do |item|
      link = item.at_css('a')
      #there must be a link
      next unless link
      href = link.attributes['href']
      agent.get(href)
      product_name = agent.page.at(elements["product_name"]).try(:content)
      #content = agent.page.at(elements["article_content"]).try(:content)
      url = agent.page.uri                                     \

      pic = nil
      pic_selector = elements["product_image"]
      if pic_selector.present?
        image_element = agent.page.at(elements["product_image"])
        pic_url = image_element[:src]
        pic = Image.new
        pic.image = download_remote_photo(pic_url)
      end

      #source_element = agent.page.at(elements["article_source"]) if elements["article_source"].present?
      #source_name = source_element ? source_element.content : ""

      generate_product(:name => product_name, :url => url, :pic => pic)
    end
  end

  def download_remote_photo(pic_url)
    io = open(URI.parse(URI.escape(pic_url)))
    def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
    rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end


  def generate_product(options={})
    product_name = options[:name].strip
    product = Product.find_or_initialize_by(name: product_name) #, provider: self.name)

    product.url = options[:url].to_s
    product.provider = self.name

    pic = options[:pic]
    if pic.present?
      pic.product_id = product.id
      pic.save!
      #product.image = options[:pic]
    end

    if product.new_record?
      if product.valid?
        product.save!
        self.count += 1
        log "#{product.name} from #{product.provider}"
      else
        log "*** invalid #{product.errors.to_s} of #{options[:url].to_s}"
      end
    else
      log "Update: #{product.name} from #{product.provider}"
    end
  end

end