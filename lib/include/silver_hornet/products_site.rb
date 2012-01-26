#coding: utf-8

require 'rubygems'
require 'rmmseg'

class SilverHornet::ProductsSite < SilverHornet::Site
  #the css selectors for the comments of a product
  attr_accessor :comment_selectors
  @@product_count ||=0
  @page_number ||=0
  @visited_first_page ||=false
  @@is_initialized ||= false
  @@brand_list ||=[]
  @@dic_words||=[]
  @@cat_words ||={}
  @@catalogs||=[]

  def initialize(skip_catalogs = false)
    #load the segmentation dictionaries
    unless @@is_initialized

      #initialize the Dictionary for word segmentation
      RMMSeg::Dictionary.add_dictionary("#{Rails.root}/lib/include/silver_hornet/dictionaries/silver.dic", :words)
      RMMSeg::Dictionary.load_dictionaries

      #load the words related to food
      load_food_word

      #load the catalogs
      load_catalogs unless skip_catalogs

      @@is_initialized = true
    end
  end

  def load_food_word
    #load the words related to food
    file = File.open("#{Rails.root}/lib/include/silver_hornet/dictionaries/silver.dic", "r")
    file.each_line do |line|
      word = line.split(" ")
      @@dic_words.push(word[1]) unless @@dic_words.include?(word[1])
    end
    file.close
  end

  #load catalogs and record them in DB
  def load_catalogs
    file = File.open("#{Rails.root}/config/silver_hornet/catalogs.yml")
    yaml = YAML.load(file)
    yaml.each do |item|
      read(item)
    end
    @@catalogs = []
    Catalog.all.each do |cat|
      @@catalogs << cat
    end
    #@@cat_words ={}
    #Catalog.all.each do |cat|
    #    if cat.alias_name.present?
    #      @@cat_words[cat]=cat.alias_name | seg_word(cat.name)
    #    else
    #      @@cat_words[cat] = seg_word(cat.name)
    #    end
    #end
  end

  def read(item)
    catalog = Catalog.find_or_initialize_by(name: item["name"])
    catalog.alias_name = item["alias_name"] if item["alias_name"].present?
    catalog.save!
    if item["sub"]
      item["sub"].each do |sub|
        child = Catalog.find_or_initialize_by(name: sub["name"])
        child.parent = catalog
        child.alias_name = sub["alias_name"] if sub["alias_name"].present?
        catalog.save!
        child.save!
        read(sub)
      end
    end
  end

  def ban_words
    @@ban_words ||= lambda do
      filename = "#{Rails.root}/config/silver_hornet/base.yml"
      file = File.open(filename)
      yaml = YAML.load(file)
      return yaml["ban_words"]
    end.call
    @@ban_words
  end

  #get all products in a site
  def fetch
    begin
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

      log "Finished at at #{Time.now.to_s}, duration #{(Time.now - timestamp)} seconds"
    rescue
      log "Something goes wrong with this website!"
      return
    end

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
        first_catalog_name = catalog_name_filter(link.try(:content))
        #initialize is_banned_catalog to filter unwanted catalog
        is_banned_catalog = !ban_words.select { |word| first_catalog_name.include? word }.empty?
        next if is_banned_catalog
        # the first-level catalog is about food
        #add the first-level catalog to tag
        tag_name=[first_catalog_name]
        #get the href attribute from the page node
        first_catalog_href = link.attributes['href']
        #some sites may use relative path, we need full path.
        if URI.parse(first_catalog_href).host.blank?
          first_catalog_href = "http://#{agent.page.uri.host}/#{first_catalog_href.to_s.gsub("../", "")}"
        end

        next unless first_catalog_href.present?
        #navigate to the detail page of the catalog and process
        log "Start process of first catalog: #{first_catalog_name}"
        #for the website which has two-level catalog of foods
        if elements["listed_second_catalog"].present?
          process_first_catalog(first_catalog_href, first_catalog_name) unless (first_catalog_href=="./" || first_catalog_href=="index.php")
        else
          #for the website which only has one-level catalog of foods. we get the product info directly.
          process_second_catalog(first_catalog_href, first_catalog_name)
        end
        log "Finished process of first catalog: #{first_catalog_name}"
      end
    end
  end


  #process the first-level catalog page and get the second-level catalog if existed or to get the product info directly
  def process_first_catalog(first_url, catalog_name)
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
          second_catalog_name = catalog_name_filter(item.try(:content))
          #get the href attr from the page node
          second_catalog_href = item.attributes['href']
          #some sites may use relative path, we need full path.
          if URI.parse(second_catalog_href).host.blank?
            second_catalog_href = "http://#{agent.page.uri.host}/#{second_catalog_href.to_s.gsub("../", "")}"
          end
          next unless second_catalog_href.present?
          #navigate to the detail page of the catalog and process
          log "Start process of second catalog: #{second_catalog_name}"
          #go to the second-level catalog page and process the product info on it
          process_second_catalog(second_catalog_href, second_catalog_name)
          log "Finished process of second catalog: #{second_catalog_name}"
        end
      end
      #the second-level catalog not exist and to get the product info directly
    else
      process_second_catalog(first_url, catalog_name)
    end
  end

  #process the product list on the catalog page and navigate to the detailed page of each product to get product info
  def process_second_catalog(second_url, catalog_name)
    #if  catalog_name == "进口饼干糕点"
    #initialize a new agent instance each time
    self.agent = Mechanize.new
    #the "Next" link which leads to another page of products
    next_link = nil
    #cache the last-page url to avoid processing the same page again
    last_visited_url = nil

    @visited_first_page=false

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

        #loop through each item listed in the page
        agent.page.search(elements["listed_product"]).each do |item|
          try do
            #try to get the link which leads to the detail page of the product
            link = item.at_css('a')
            #there must be a link
            next unless (link.present? && link.attributes.present?)
            href = link.attributes['href']
            next if href.value=="http://www.yihaodian.com/product/1079998"
            #some sites may use relative path, we need full path.
            if URI.parse(href).host.blank?
              href = "http://#{agent.page.uri.host}/#{href.to_s.gsub("../", "")}"
            end
            next unless href.present?
            #navigate to thedetail page of the product
            agent.get(href)
            #process the product info
            process_product(catalog_name)
          end
        end
        #go back to the entry page we cached before
        agent.get(start_url)
        #try to find the "Next" page
        next_link = get_next_link
      end
    end while next_link
    #end
  end

  def handle_url(url_string)
    begin
      url = URI.parse(url_string)
    rescue
      url = nil
    end

    if url && url.path && url.query
      'http://' + (url.host ? url.host : "") + url.path + '?' +url.query
    else
      nil
    end
  end

  #process the detailed product info
  def process_product(catalog_name)
    product = nil
    try do
      #get the product name
      product_name = catalog_name_filter(agent.page.at(elements["product_name"]).try(:content))
      #there exists a product
      unless product_name.blank?
        #according to the name, either find the product from database or initialize a new one
        product = Product.find_or_initialize_by(name: product_name)
        #try to find the vendor
        if name == I18n.t("third_party.taobao")
          @taobao ||= Mall.first(conditions: {name: I18n.t("third_party.taobao")})

          if elements["product_vendor"].present?
            arr = elements["product_vendor"]
            arr.each do |selector|
              nick = agent.page.at(selector).try(:content)
              if nick
                vendor = Vendor.find_or_initialize_by(name: nick, mall_id: @taobao.id)
                if vendor.new_record?
                  vendor.save!
                end
                #set the vendor
                product.vendor = vendor
                break
              end
            end
          end
        else
          product.vendor = Vendor.first(conditions: {name: self.name})
        end
        #record the product's ulr
        product.url = handle_url(agent.page.uri.to_s)
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

        #initialize the tags of product
        product.tags=[]
        #get the tag
        product.tags = seg_word(product_name)

        product.catalogs = []
        #set the product catalog
        get_product_catalog(catalog_name, product) if catalog_name.present?

        #record the product
        if product.new_record?
          if product.valid?
            #everything is ok, save the new object to DB
            product.save!
            #calculate the product amount
            @@product_count+=1
            log "Insert #{product.name} of tag: #{product.tags} of Catalogs: #{product.catalogs.each { |cat| p cat.name }} from #{product.url}"
          else
            #somethings goes wrong
            log "Invalid #{product.errors.to_s} of #{product.url}"
          end
        else
          if product.changed?
            #update the change
            product.save!
            log "Update: #{product.name} of tag: #{product.tags} of Catalogs: #{product.catalogs.each { |cat| p cat.name }} from #{product.url}"
          end
        end
      else
        log "Cannot get the product name at: #{agent.page.uri.to_s}"
      end

    end

    product
  end


  def process_taobao_product
    product = nil
    try do
      #get the product name
      product_name = agent.page.at('input[type=hidden][name=title]').attr('value').to_s
      #according to the name, either find the product from database or initialize a new one
      product = Product.find_or_initialize_by(name: product_name)
      #try to find the vendor

      taobao = Mall.find_or_initialize_by(name: I18n.t("third_party.taobao"))
      taobao.save if taobao.new_record?
      nick = agent.page.at('input[type=hidden][name=seller_nickname]').attr('value').to_s
      vendor = Vendor.find_or_initialize_by(name: nick, mall_id: taobao.id)
      vendor.save if vendor.new_record?
      #set the vendor
      product.vendor = vendor
      #record the product's ulr
      product.url = handle_url(agent.page.uri.to_s)
      #record the product's price
      product_price = agent.page.at('input[type=hidden][name=current_price]').attr('value').to_s
      #delete the symbols of price
      money_symbols = [I18n.t("money.yuan_mark1"), I18n.t("money.yuan"), I18n.t("money.yuan_mark2")].join
      product_price = product_price.gsub(/[#{money_symbols}]/, '').strip
      product.price = product_price.to_f

      pic_url = agent.page.at('input[type=hidden][name=photo_url]').attr('value').to_s
      pic_url =  'http://img01.taobaocdn.com/bao/uploaded/' + pic_url + '_310x310.jpg'

      if product.image.blank? || product.image.remote_picture_url != pic_url
        #we are using Carrierwave, so just set the remote_picture_url, it will download the image for us
        pic = product.create_image(remote_picture_url: pic_url)
      end

      #initialize the tags of product
      product.tags=[]
      #get the tag
      product.tags = seg_word(product_name)

      product.catalogs = []
      #set the product catalog

      product.save!
    end

    product
  end


  #Filtering the unwanted symbols
  def catalog_name_filter(name)
    return name.to_s.strip.gsub(/[\r\n\t(商品名称：)]/, "")
  end


  def get_next_link
    #for the page link is extremely ugly,e.g first page has no "next link",but next page has!!
    if elements["fuck_page_number"].present?
      if @visited_first_page==false
        @visited_first_page=true
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
        if @page_number != agent.page.at(elements["next_page_number_link"]).search('a').size
          @page_number +=1
          agent.page.at(elements["next_page_number_link"]).search('a')[@@page_number]
        else
          @page_number = 0
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
      money_symbols = [I18n.t("money.yuan_mark1"), I18n.t("money.yuan_mark2"), I18n.t("money.yuan")].join
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

      if product.image.blank? || product.image.remote_picture_url != pic_url
        #we are using Carrierwave, so just set the remote_picture_url, it will download the image for us
        pic = product.create_image(remote_picture_url: pic_url)
      end
    end
  end

  def seg_word(word)
    words =[]
    algor = RMMSeg::Algorithm.new(word)
    loop do
      tok = algor.next_token
      break if tok.nil?
      unless words.empty?
        words.push(tok.text.force_encoding("UTF-8")) if @@dic_words.include?(tok.text.force_encoding("UTF-8")) && !words.include?(tok.text.force_encoding("UTF-8"))
      else
        words.push(tok.text.force_encoding("UTF-8")) if @@dic_words.include?(tok.text.force_encoding("UTF-8"))
      end
    end
    return words
  end

  def get_product_catalog(cat_name, product)
    try do
      cat_tags = seg_word(cat_name)
      @@catalogs.each do |cat|
        cat_words=[]
        if cat.alias_name.present?
          cat_words=cat.alias_name | seg_word(cat.name)
        else
          cat_words = seg_word(cat.name)
        end
        cat_words.each do |cat_word|
          if cat_tags.include?(cat_word)
            product.catalogs << cat unless product.catalogs.include?(cat)
            if cat.children.present?
              cat.children.all.each do |child|
                unless product.catalogs.include?(child)
                  if seg_word(product.name).include?(child.name)
                    product.catalogs << child
                    break
                  else
                    if child.alias_name.present?
                      child.alias_name.each do |alias_name|
                        if seg_word(product.name).include?(alias_name)
                          product.catalogs << child
                          break
                        end
                      end
                    end
                  end
                else
                  break
                end
              end
            end
          end
        end
      end
      if product.catalogs.size > 1
        word = seg_word(product.name)
        catalogs ={}
        product.catalogs.each do |catalog|
          if catalogs[catalog.ancestry].present?
            catalogs[catalog.ancestry] = catalogs[catalog.ancestry].to_s + "," + catalog.id.to_s
          else
            catalogs[catalog.ancestry] = catalog.id.to_s
          end
        end
        catalogs.each do |(key, value)|
          cat_id = value.split(",").uniq
          if cat_id.size > 1
            cat_id.each do |id|
              is_related = false
              if Catalog.find(id).alias_name.present?
                words = Catalog.find(id).alias_name | seg_word(Catalog.find(id).name)
                words.each do |w|
                  if word.include?(w)
                    is_related = true
                  end
                end
              else
                words = seg_word(Catalog.find(id).name)
                words.each do |w|
                  if word.include?(w)
                    is_related = true
                  end
                end
              end
              unless is_related
                product.catalogs.delete(Catalog.find(id))
              end
            end
          end
          if product.catalogs.size < 1
            product.catalogs <<  Catalog.find(cat_id[0]) unless product.catalogs.include?(Catalog.find(cat_id[0]))
          end
        end
      end
    end
  end

end
