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
      next_link = nil
      begin
        begin
          if next_link.nil?
            agent.get(entry_url)
          elsif next_link.attributes['href'].to_s != agent.page.uri.to_s
            agent.click(next_link)
            next_link = nil
          else
            next
          end
          start_url = agent.page.uri

          log "Now dealing with #{name}: #{agent.page.uri.to_s}, see #{agent.page.search("#{elements["listed_product"]} a").size.to_s} products."
          agent.page.search(elements["listed_product"]).each do |item|
            link = item.at_css('a')
            #there must be a link
            next unless link.present?
            href = link.attributes['href']
            next unless href.present?
            agent.get(href)

            process_product
          end

          #go back to the entry page
          agent.get(start_url)
          if elements["next_link_css_selector"].present?
            next_link = agent.page.at(elements["next_link_css_selector"])
          elsif elements["next_link_text"].present?
            next_link = agent.page.link_with(:text => elements["next_link_text"])
          end

          log "Got #{count.to_s} products on #{name}: #{agent.page.uri.to_s}"
        rescue Errno::ETIMEDOUT, Timeout::Error, Net::HTTPNotFound
          log "Connection Error"
        rescue Exception => exc
          log exc.message
          log exc.backtrace
        end
      end while next_link
    end

    log "Finished at at #{Time.now.to_s}, duration #{(Time.now - timestamp)} seconds"
  end

  def process_product
    doc = Nokogiri::HTML(agent.page.body)
    product_name = doc.at_css(elements["product_name"]).try(:content)
    product = Product.find_or_initialize_by(name: product_name) #, provider: self.name)
    product.vendor = Vendor.first(conditions: {name: self.name})
    product.url = agent.page.uri.to_s

    get_price(product, doc)
    get_field(product, doc, :weight, "product_weight")
    get_field(product, doc, :producer, "product_producer")
    get_field(product, doc, :original_place, "product_original_place")
    get_field(product, doc, :description, "product_description")

    get_image(product, doc)
    get_comments(product)

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
    product.send("#{field_name}=", value) if product.respond_to?("#{field_name}=")
  end

  def get_price(product, doc)
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

  def get_image(product, doc)
    pic = nil
    pic_selector = elements["product_image"]
    if pic_selector.present?
      image_element = doc.at_css(elements["product_image"])
      pic_url = image_element[:src] if image_element.present?

      if product.image.blank? || product.image.remote_image_url != pic_url
        pic = product.build_image(:remote_image_url => pic_url)
        pic.remote_image_url = pic_url
        #pic.image = download_remote_photo(pic_url)
        pic.save!
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