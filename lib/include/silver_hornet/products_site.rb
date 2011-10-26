class SilverHornet::ProductsSite < SilverHornet::Site
  attr_accessor :comment_selectors

  def fetch
    if skipped.present? && skipped == true
      log "#{name} is skipped"
      return
    end

    timestamp = Time.now
    log "Fetching products from #{self.name} at #{timestamp.to_s}"

    self.entries.each do |entry_url|
      try do
        process_entry(entry_url)
      end
    end

    log "Finished at at #{Time.now.to_s}, duration #{(Time.now - timestamp)} seconds"
  end

  def process_entry(url)
    next_link = nil
    begin
      try do
        if next_link.nil?
          agent.get(url)
        else
          agent.click(next_link)
          next_link = nil
        end
        start_url = agent.page.uri

        log "Now dealing with #{name}: #{agent.page.uri.to_s}, see #{agent.page.search("#{elements["listed_product"]} a").size.to_s} products."
        agent.page.search(elements["listed_product"]).each do |item|
          try do
            link = item.at_css('a')
            #there must be a link
            next unless (link.present? && link.attributes.present?)
            href = link.attributes['href']
            next unless href.present?
            agent.get(href)

            process_product
          end
        end

        #go back to the entry page
        agent.get(start_url)
        next_link = get_next_link

        log "Got #{count.to_s} products on #{name}: #{agent.page.uri.to_s}"
      end
    end while next_link
  end

  def process_product
    self.doc = Nokogiri::HTML(agent.page.body)
    product_name = doc.at_css(elements["product_name"]).try(:content)
    product = Product.find_or_initialize_by(name: product_name) #, provider: self.name)
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

  def get_next_link
    if elements["next_link_css_selector"].present?
      agent.page.at(elements["next_link_css_selector"])
    elsif elements["next_link_text"].present?
      agent.page.link_with(:text => elements["next_link_text"])
    else
      nil
    end
  end

  def get_field(product, field_name, element_name)
    selector = elements[element_name]
    return unless selector.present?

    value = doc.at_css(selector).try(:content)
    product.send("#{field_name}=", value) if product.respond_to?("#{field_name}=")
  end

  def get_price(product)
    selector = elements["product_price"]
    return unless selector.present?

    value = doc.at_css(selector).try(:content)
    if value.present?
      money_symbols = [I18n.t("money.yuan_mark"), I18n.t("money.yuan")].join
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
    @categories ||= Category.all.to_a

    @categories.each do |c|
      product.category = c if product.name.include?(c.name)

    end
  end

  #def get_weight(product, doc)
  #  selector = elements["product_weight"]
  #  if selector.present?
  #    value = doc.at_css(selector).try(:content)
  #    product.weight = Float(value) if value.present?
  #  else
  #    weight_symbols = [I18n.t("weight.gram_mark"), I18n.t("weight.gram")].join
  #    results = product.name.grep(/ (.+)[#{weight_symbols}]/)
  #    if results.any?
  #      product.weight = Float(results.last)
  #      p product.weight.to_s + "G"
  #    end
  #  end
  #end

  def get_image(product)
    pic = nil
    pic_selector = elements["product_image"]
    if pic_selector.present?
      image_element = doc.at_css(elements["product_image"])
      pic_url = image_element[:src] if image_element.present?

      if URI.parse(pic_url).host.blank?
        pic_url = "http://#{agent.page.uri.host}/#{pic_url}"
      end

      if product.image.blank? || product.image.remote_image_url != pic_url
        pic = product.create_image(remote_image_url: pic_url)
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