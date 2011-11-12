#encoding: utf-8

require 'rubygems'
require 'rmmseg'

class SilverHornet::Buy < SilverHornet::Site
  #the css selectors for the comments of a product
  attr_accessor :comment_selectors
  @@product_count ||=0
  @@page_number ||=0
  @@visited_first_page ||=false

  def initialize(*args)
    unless @@dic_loaded
      #initialize the Dictionary for word segmentation
      RMMSeg::Dictionary.add_dictionary("#{Rails.root}//lib//include//silver_dictionaries//yin11.dic", :words)
      RMMSeg::Dictionary.load_dictionaries
      @@dic_loaded = true
    end

    super(*args)
  end

  def ban_words
    @@ban_words ||= lambda do
        filename = "#{Rails.root}/config/silver_hornet/product_global.yml"
        file     = File.open(filename)
        yaml     = YAML.load(file)
    return yaml["ban_words"]
    @@ban_words
  end

  #get all products in a site
  def fetch
    if skipped.present? && skipped == true
      log "#{name} is skipped"
      return
    end

    timestamp = Time.now
    log "Fetching catalogs from #{self.name} at #{timestamp.to_s}"

    #loop through each entry_url
    self.entries.each do |entry_url|
      try do
        process_main_catalog(entry_url)
      end
    end

    log "We have got #{@@product_count} Products in #{name}!"

    #log "Finished at at #{Time.now.to_s}, duration #{(Time.now - timestamp)} seconds"
  end

  # process the entry page of the website and get the first-level catalog
  def process_main_catalog(url)
    #initialize a new agent instance each time
    self.agent = Mechanize.new
    agent.get(url)
    agent.page.search(elements["listed_first_catalog"]).each do |link|
      #get the child tag
      try do
        #get sub catalog's name
        first_catalog_name = string_filter(child.try(:content))
        #initialize is_banned_catalog to filter unwanted catalog
        is_banned_catalog = ban_words.exists?{|word| first_catalog_name.include? word }
        next if is_banned_catalog
        # the first-level catalog is about food
        #add the first-level catalog to tag
        tag_name=[first_catalog_name]
        #get the href attribute from the page node
        first_catalog_href = child.attributes['href']
        #some sites may use relative path, we need full path.
        if URI.parse(first_catalog_href).host.blank?
          first_catalog_href = "http://#{agent.page.uri.host}/#{first_catalog_href.to_s.gsub("../", "")}"
        end

        next unless first_catalog_href.present?
          #navigate to the detail page of the catalog and process
          log "Start process #{first_catalog_name}"
        if
          #for the website which has two-level catalog of foods
        elements["listed_second_catalog"].present?
          process_first_catalog(first_catalog_href, tag_name) unless (first_catalog_href=="./" || first_catalog_href=="index.php")
        else
          #for the website which only has one-level catalog of foods. we get the product info directly.
          process_second_catalog(first_catalog_href, tag_name)
        end
        log "Finished process #{first_catalog_name}"
        #c = Cetegory.new(:name => catalog_name)
        #c.save
        end
      end
    end
  end

  #process the first-level catalog page and get the second-level catalog if existed or to get the product info directly
  def process_first_catalog(first_url, first_catalog_tag)
    #initialize a new agent instance each time
    self.agent = Mechanize.new
    #go on the site searched
    agent.get(first_url)
    #check if exist second-level catalog
    second_catalogs = agent.page.search("#{elements["listed_second_catalog"]}")
    if second_catalogs.size>0
      # there exist second-level catalog,but the catalog is complex. e.g the tag <div> has many tag <a>
      second_catalogs.each do |item|
        try do
          #get sub catalog's name
          second_catalog_name = string_filter(item.try(:content))
          #add second-level catalog to the tag
          start_tag = [first_catalog_tag]
          tag_name = start_tag
          log "tag name in first process: #{tag_name}"
          tag_name.push(second_catalog_name)
          #get the href attr from the page node
          second_catalog_href = second_catalog_link.attributes['href']
          #some sites may use relative path, we need full path.
          if URI.parse(second_catalog_href).host.blank?
            second_catalog_href = "http://#{agent.page.uri.host}/#{second_catalog_href.to_s.gsub("../", "")}"
          end
          next unless second_catalog_href.present?
          #navigate to the detail page of the catalog and process
          #agent.get(href)
          log "Start process #{second_catalog_name}"
          #go to the second-level catalog page and process the product info on it
          process_second_catalog(second_catalog_href, tag_name)
          log "Finished process #{second_catalog_name}"
          #c = Cetegory.new(:name => catalog_name)
          #c.save
        end
      end
      #the second-level catalog not exist and to get the product info directly
    else
      process_second_catalog(first_url, first_catalog_tag)
    end
  end

  #process the product list on the catalog page and navigate to the detailed page of each product to get product info
  def process_second_catalog(second_url, second_catalog_tag)
    #initialize a new agent instance each time
    self.agent = Mechanize.new
    #initialize the tag
    tag_name=second_catalog_tag
    #the "Next" link which leads to another page of products
    next_link = nil
    #cache the last-page url to avoid processing the same page again
    last_visited_url = nil

    @@visited_first_page=false

    begin
      try do
        #the entry page it self
        if next_link.nil?
          agent.get(second_url)
          last_visited_url = agent.page.uri.to_s
        else
          last_visited_url = agent.page.uri.to_s
          #click the next page
          agent.click(next_link)
          #avoid processing the page visited
          if agent.page.uri.to_s == last_visited_url
            return
          end
          next_link = nil
        end

        #cache the current url, we will be back later
        start_url = agent.page.uri

        log "Now dealing with #{name}: #{agent.page.uri.to_s}, see #{agent.page.search("#{elements["listed_product"]}").size.to_s} products."
        #@@product_count+=agent.page.search("#{elements["listed_product"]}").size

        #loop through each item listed in the page
        agent.page.search(elements["listed_product"]).each do |item|
          try do
            #try to get the link which leads to the detail page of the product
            link = item.at_css('a')
            #there must be a link
            next unless (link.present? && link.attributes.present?)
            href = link.attributes['href']
            #some sites may use relative path, we need full path.
            if URI.parse(href).host.blank?
              href = "http://#{agent.page.uri.host}/#{href.to_s.gsub("../", "")}"
            end
            next unless href.present?
            #navigate to the detail page of the product
            agent.get(href)
            #process the product info
            process_product(tag_name)
          end
        end
        #go back to the entry page we cached before
        agent.get(start_url)
        #try to find the "Next" page
        next_link = get_next_link
      end
    end while next_link
  end


#process the detailed product info
  def process_product(catalog_tag)
    #get the product name
    product_name = string_filter(agent.page.at(elements["product_name"]).try(:content))
    #initialize another tags for precise tagging the product by word segmenting its name
    #tags=tag
    #segmenting the product name in order to get its tags
    #algor = RMMSeg::Algorithm.new(product_name)
    #loop do
    #  tok = algor.next_token
    #  break if tok.nil?
    #  puts "#{tok.text} [#{tok.start}..#{tok.end}]"
    #end

    #log product_name
    #there exists a product
    unless product_name.blank?
      #according to the name, either find the product from database or initialize a new one
      product = Product.find_or_initialize_by(name: product_name)
      #try to find the vendor
      product.vendor = Vendor.first(conditions: {name: self.name})
      #record the product's ulr
      product.url = agent.page.uri.to_s
      #record the product's price
      if elements["product_price"].present?
        product_price = agent.page.at(elements["product_price"]).try(:content)
        #delete the symbols of price
        if product_price.present?
          money_symbols = [I18n.t("money.yuan_mark1"), I18n.t("money.yuan"), I18n.t("money.yuan_mark2")].join
          product_price = product_price.gsub(/[#{money_symbols}]/, '').strip
          product.price = product_price.to_f
        else
          log "No Price is Found!"
        end
      end
      #get the product's image
      get_image(product)

      #get_field(product, :weight, "product_weight")
      #get_field(product, :producer, "product_producer")
      #get_field(product, :original_place, "product_original_place")
      #get_field(product, :description, "product_description")
      #get_comments(product)

      #record the product
      if product.new_record?
        if product.valid?
          #record the catalog tag of product
          product.tags=catalog_tag
          #everything is ok, save the new object to DB
          product.save!
          #calculate the product amount
          @@product_count+=1
          log "Insert #{product.name} of #{product.tags}"
        else
          #somethings goes wrong
          log "Invalid #{product.errors.join} of #{product.url}"
        end
      else
        if product.changed?
          #check whether the tag exists, and update the tags for the product
          catalog_tag.each do |tag|
            unless product.tags.include?(tag)
              product.tags.push(tag)
            end
          end
          #update the change
          product.save!
          log "Update: #{product.name} of #{product.tags}"
        end
      end
    else
      log "Cannot get the product name at: #{agent.page.uri.to_s}"
    end
  end


  def string_filter(name)
    return name.to_s.strip.gsub(/[\r\n\t(商品名称：)]/, "")
  end


  def get_next_link
    #for the page link is extremely ugly,e.g first page has no "next link",but next page has!!
    if elements["fuck_page_number"].present?
      if @@visited_first_page==false
        @@visited_first_page=true
        agent.page.at(elements["next_page_number_link"]).search('a')[@@page_number+1]
      else
        #if there is a CSS selector
        if elements["next_link_css_selector"].present?
          if agent.page.at(elements["next_link_css_selector"]).attributes['href'].present?
            agent.page.at(elements["next_link_css_selector"])
          else
            nil
          end
          #or find the wrods for "Next Page"
        elsif elements["next_link_text"].present?
          agent.page.link_with(:text => elements["next_link_text"])
        end
      end
    else
      #if there is a CSS selector
      if elements["next_link_css_selector"].present?
        if agent.page.at(elements["next_link_css_selector"]).attributes['href'].present?
          agent.page.at(elements["next_link_css_selector"])
        else
          nil
        end
        #or find the wrods for "Next Page"
      elsif elements["next_link_text"].present?
        agent.page.link_with(:text => elements["next_link_text"])
        #for the page has no "Next"  button
      elsif elements["next_page_number_link"].present?
        #check if is the last page
        if @@page_number != agent.page.at(elements["next_page_number_link"]).search('a').size
          @@page_number +=1
          #p @@page_number
          agent.page.at(elements["next_page_number_link"]).search('a')[@@page_number]
        else
          @@page_number = 0
        end
      else
        nil
      end
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
      money_symbols = [I18n.t("money.yuan_mark"), I18n.t("money.yuan")].join
      product.price = value.gsub(/[#{money_symbols}]/, '').strip
    end
    product.price
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

    #according to the product's name, try assigning a category for the product
    @categories.each do |c|
      product.category = c if product.name.include?(c.name)
    end
  end

  def get_image(product)
    pic = nil
    pic_selector = elements["product_image"]
    if pic_selector.present?
      image_element = agent.page.at(elements["product_image"])
      #get the url of the image
      pic_url = image_element[:src] if image_element.present?

      #some sites may use relative path, we need full path.
      if URI.parse(pic_url).host.blank?
        pic_url = "http://#{agent.page.uri.host}/#{pic_url}"
      end

      #log "the image's url is: #{pic_url}"

      if product.image.blank? || product.image.remote_image_url != pic_url
        #we are using Carrierwave, so just set the remote_image_url, it will download the image for us
        pic = product.create_image(remote_image_url: pic_url)
      end
    end
  end

end
