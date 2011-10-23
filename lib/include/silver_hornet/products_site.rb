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

          log "Now dealing with #{name}: #{agent.page.uri.to_s}, see #{agent.page.search("#{elements["listed_product"]} a").size.to_s} products."
          agent.page.search(elements["listed_product"]).each do |item|
            link = item.at_css('a')
            #there must be a link
            next unless link
            href = link.attributes['href']
            agent.get(href)

            process_product(agent)
          end

          #go back to the entry page
          agent.get(start_url)
          if elements["next_link_css_selector"].present?
            next_link = agent.page.at(elements["next_link_css_selector"])
          elsif elements["next_link_text"].present?
            next_link = agent.page.link_with(:text => elements["next_link_text"])
          end

          log "Got #{count.to_s} products on #{name}: #{agent.page.uri.to_s}"
        end while next_link
      end
    rescue Exception => exc
      log exc.message
      log exc.backtrace
    end
  end

  def process_product(agent)
    doc = Nokogiri::HTML(agent.page.body)
    product_name = doc.at_css(elements["product_name"]).try(:content)
    product = Product.find_or_initialize_by(name: product_name) #, provider: self.name)
    product.vendor = Vendor.first(conditions: {name: self.name})
    product.url = agent.page.uri.to_s
    #
    get_field(product, doc, :price, "product_price")
    get_field(product, doc, :weight, "product_weight")
    get_field(product, doc, :producer, "product_producer")
    get_field(product, doc, :original_place, "product_original_place")
    get_field(product, doc, :description, "product_description")

    get_image(product, doc)

    if product.new_record?
      if product.valid?
        product.save!
        self.count += 1
        log "#{product.name} from #{self.name}"
      else
        log "*** invalid #{product.errors.to_s} of #{product.url}"
      end
    else
      if product.changed?
        product.save!
        log "Update: #{product.name} from #{product.vendor.name}"
      end
    end

    #source_element = agent.page.at(elements["article_source"]) if elements["article_source"].present?
    #source_name = source_element ? source_element.content : ""
  end

  def get_field(product, doc, field_name, element_name)
    selector = elements[element_name]
    return unless selector.present?

    value = doc.at_css(selector).try(:content)
    #if field_name == :price
    #  value = value.gsub(I18n.t "products.price_mark",'')
    #end
    product.send("#{field_name}=", value) if product.respond_to?("#{field_name}=")
  end

  def get_image(product, doc)
    pic = nil
    pic_selector = elements["product_image"]
    if pic_selector.present?
      image_element = doc.at_css(elements["product_image"])
      pic_url = image_element[:src] if image_element.present?
      pic = Image.new
      pic.image = download_remote_photo(pic_url)
      pic.product_id = product.id
      #TODO
      pic.save!
    end
  end

  def download_remote_photo(pic_url)
    io = open(URI.parse(URI.escape(pic_url)))
    def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
    rescue Exception => exc
      log exc.message
      log exc.backtrace
      # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

end