class SilverHornet::ProductsSite < SilverHornet::Site
  #the css selectors for the comments of a product
  attr_accessor :comment_selectors

  #get all products in a site
  def fetch
    if skipped.present? && skipped == true
      log "#{name} is skipped"
      return
    end

    timestamp = Time.now
    log "Fetching products from #{self.name} at #{timestamp.to_s}"

    #loop through each entry_url
    self.entries.each do |entry_url|
      try do
        process_entry(entry_url)
      end
    end

    log "Finished at at #{Time.now.to_s}, duration #{(Time.now - timestamp)} seconds"
  end

  def process_entry(url)
    # the "Next" link which leads to another page of products
    next_link = nil
    begin
      try do
        #the entry page it self
        if next_link.nil?
          agent.get(url)
        #click the next page
        else
          agent.click(next_link)
          next_link = nil
        end
        #cache the current url, we will be back later
        start_url = agent.page.uri

        log "Now dealing with #{name}: #{agent.page.uri.to_s}, see #{agent.page.search("#{elements["listed_product"]} a").size.to_s} products."
        #loop through each item listed in the page
        agent.page.search(elements["listed_product"]).each do |item|
          try do
            #try to get the link which leads to the detail page of the product
            link = item.at_css('a')
            #there must be a link
            next unless (link.present? && link.attributes.present?)
            href = link.attributes['href']
            next unless href.present?
            #navigate to the detail page of the product
            agent.get(href)

            process_product
          end
        end

        #go back to the entry page we cached before
        agent.get(start_url)
        #try to find the "Next" page
        next_link = get_next_link

        log "Got #{count.to_s} products on #{name}: #{agent.page.uri.to_s}"
      end
    end while next_link
  end

  def process_product
    #set the doc variable
    self.doc = Nokogiri::HTML(agent.page.body)
    product_name = doc.at_css(elements["product_name"]).try(:content)
    #according to the name, either find the product from database or initialize a new one
    product = Product.find_or_initialize_by(name: product_name) #, provider: self.name)
    #try to find the vendor
    product.vendor = Vendor.first(conditions: {name: self.name})
    product.url = agent.page.uri.to_s

    get_price(product)
    get_field(product, :weight, "product_weight")
    get_field(product, :producer, "product_producer")
    get_field(product, :original_place, "product_original_place")
    get_field(product, :description, "product_description")

    get_image(product)
    get_comments(product)
    assign_category(product)

    if product.new_record?
      if product.valid?
        #everything is ok, save the new object to DB
        product.save!
        self.count += 1
        log "#{product.name} from #{self.name}"
      else
        #somethings goes wrong
        log "*** invalid #{product.errors.to_s} of #{product.url}"
      end
    else
      if product.changed?
        #update the change
        product.save!
        log "Update: #{product.name} from #{product.vendor.name}"
      end
    end
  end

  def get_next_link
    #if there is a CSS selector
    if elements["next_link_css_selector"].present?
      agent.page.at(elements["next_link_css_selector"])
    #or find the wrods for "Next Page"
    elsif elements["next_link_text"].present?
      agent.page.link_with(:text => elements["next_link_text"])
    else
      nil
    end
  end

  def get_field(product, field_name, element_name)
    #use the given CSS selector, find a value, and set it to the given field of the product
    selector = elements[element_name]
    return unless selector.present?

    value = doc.at_css(selector).try(:content)
    #try to set the value
    product.send("#{field_name}=", value) if product.respond_to?("#{field_name}=")
  end

  def get_price(product)
    selector = elements["product_price"]
    return unless selector.present?

    value = doc.at_css(selector).try(:content)
    if value.present?
      money_symbols = [I18n.t("money.yuan_mark1"), I18n.t("money.yuan_mark2"), I18n.t("money.yuan")].join
      product.price = value.gsub(/[#{money_symbols}]/, '')
    end
  end

  def get_comments(product)
    return unless comment_selectors.present? && (comment_selectors[:skip_comments].blank? || comment_selectors[:skip_comments] == false)
    return unless comment_selectors["listed_comment"].present? && comment_selectors["comment_text"].present?

    next_link = nil
    begin
      agent.click(next_link) if next_link

      agent.page.search(comment_selectors["listed_comment"]).each do |comment|
        content = comment.at_css(comment_selectors["comment_text"]).try(:content)
        p content
        product.comments << Comment.new(:content => content)
      end

      next_link = agent.page.at(comment_selectors["next_commnet_css_selector"]) if comment_selectors["next_commnet_css_selector"].present?
    end while next_link
  end

  def assign_category(product)
    @categories ||= Tag.categories

    #according to the product's name, try assigning a category for the product
    @categories.each do |c|
      product.tags << c.name if product.name.include?(c.name)
    end
  end

  def get_image(product)
    pic = nil
    pic_selector = elements["product_image"]
    if pic_selector.present?
      image_element = doc.at_css(elements["product_image"])
      #get the url of the image
      pic_url = image_element[:src] if image_element.present?

      #some sites may use relative path, we need full path.
      if URI.parse(pic_url).host.blank?
        pic_url = "http://#{agent.page.uri.host}/#{pic_url}"
      end

      if product.image.blank? || product.image.remote_pictire_url != pic_url
        #we are using Carrierwave, so just set the remote_pictire_url, it will download the image for us
        pic = product.create_image(remote_pictire_url: pic_url)
      end
    end
  end

  #def download_remote_photo(pic_url)
  #  io = open(URI.parse(URI.escape(pic_url)))
  #  def io.original_filename; base_uri.path.split('/').last; end
  #    io.original_filename.blank? ? nil : io
  #  rescue Exception => exc
  #    log exc.message
  #    log exc.backtrace
  #    # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  #end

end