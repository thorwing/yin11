#coding: utf-8

require 'crack/xml'
require 'rubygems'
require 'rmmseg'

class SilverHornet::TaobaoHornet

  @@cat_words ||={}

  def initialize

    @product_count=0

    #initialize the taobao fetch config
    config

    #initialize the Dictionary for word segmentation
    RMMSeg::Dictionary.add_dictionary("#{Rails.root}/lib/include/silver_hornet/dictionaries/silver.dic", :words)
    RMMSeg::Dictionary.load_dictionaries

    #load the words related to food
    load_food_word

    #load the catalogs
    load_catalogs
  end

  def config
    @config ||= lambda do
      filename = "#{Rails.root}/config/silver_hornet/taobao.yml"
      file = File.open(filename)
      yaml = YAML.load(file)
      return yaml
    end.call
    @config
  end

  def load_food_word
    #initialize the dic_words
    @dic_words =[]
    #load the words related to food
    file = File.open("#{Rails.root}/lib/include/silver_hornet/dictionaries/silver.dic", "r")
    file.each_line do |line|
      word = line.split(" ")
      @dic_words.push(word[1]) unless @dic_words.include?(word[1])
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
    @@cat_words ={}
    Catalog.all.each do |cat|
      if cat.alias_name.present?
        @@cat_words[cat] = cat.alias_name | seg_word(cat.name)
      else
        @@cat_words[cat] = seg_word(cat.name)
      end
    end
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

  def fetch
    #initialize a hash
    @catalog = {}
    #get the all subcatalogs on taobao from parent_cid, and make them into the hash pairs
    @config["root_cid"].each { |key, value| @catalog.merge!(fetch_catalog(key, value)) }
    #for each catalog, get the response xml file by posing a restful WS url, and then process the product on it
    unless @catalog.empty?
      @catalog.each { |(key, value)| get_xml(1, 40, key, value) }
    else
      p "Taobao ID is banned!"
    end
    #count the total product amount
    p "We've got #{@product_count} product!"
  end

  #get the all subcatalogs on taobao from parent_cid
  def fetch_catalog(parent_cid, parent_name)
    retry_times = 5
    time = Time.now
    #parameters of http request
    parameters = {
        :timestamp => time.strftime("%Y-%m-%d %H:%M:%S"),
        :app_key => @config["key"],
        :method => "taobao.itemcats.get",
        :partner_id => "top-apitools",
        :format => "xml",
        :fields => "cid,name,parent_cid",
        :sign_method => "md5",
        :v => "2.0",
        :parent_cid => parent_cid
    }
    parameters[:sign] = ::Digest::MD5.hexdigest(@config["secret"] + parameters.sort.flatten.join + @config["secret"]).upcase
    #to replace the blank ' '
    parameters[:timestamp] = time.strftime("%Y-%m-%d+%H:%M:%S")
    #return the restful WS address
    uri = URI.parse("http://gw.api.taobao.com/router/rest?#{convert_to_http_params(parameters)}")
    #get the response which is a xml file
    begin
      response = Net::HTTP.get(uri)
    rescue StandardError => ex_msg
      p ex_msg
      retry if (retry_times -= 1) > 0
    end
    #make xml file into a hash
    xml_doc = Crack::XML.parse(response)
    if xml_doc.present? && xml_doc["itemcats_get_response"].present?
      #for each subcatalog to process the products related to
      xml_doc["itemcats_get_response"]["item_cats"]["item_cat"].each do |cat|
        @catalog[cat["cid"]]=cat["name"]+":"+parent_name
        fetch_catalog(cat["cid"], cat["name"])
      end
    end
    return @catalog
  end

  #get the response xml file by posing a restful WS url
  def get_xml(page_no, page_size, cid, cat_name)
    #get the restful WS url
    p "page_no: #{page_no}"
    uri = get_uri(page_no, page_size, cid)
    #get the response xml file
    response = Net::HTTP.get(uri)
    xml_doc = Crack::XML.parse(response)
    #process the product info on xml file
    process_product(xml_doc, cat_name)
    #count the page number
    total_no=(xml_doc["items_get_response"]["total_results"].to_i/page_size).to_i+1
    if page_no<=total_no
      page_no+=1
      get_xml(page_no, page_size, cid, cat_name)
    end
  end

  #get the restful WS url for products
  def get_uri(page_no, page_size, cid)
    p_no=page_no
    p_size=page_size
    #parameters of http request
    time = Time.now
    parameters = {
        :timestamp => time.strftime("%Y-%m-%d %H:%M:%S"),
        :app_key => @config["key"],
        :method => "taobao.items.get",
        :partner_id => "top-apitools",
        :format => "xml",
        :fields => "num_iid,title,nick,pic_url,price",
        :sign_method => "md5",
        :v => "2.0",
        :cid => "#{cid.to_s}",
        :start_score => "13",
        :is_mall =>"true",
        :page_size => "#{p_size.to_s}",
        :page_no => "#{p_no.to_s}"
    }
    parameters[:sign] = ::Digest::MD5.hexdigest(@config["secret"] + parameters.sort.flatten.join + @config["secret"]).upcase
    #to replace the blank ' '
    parameters[:timestamp] = time.strftime("%Y-%m-%d+%H:%M:%S")
    #return the restful WS address
    uri = URI.parse("http://gw.api.taobao.com/router/rest?#{convert_to_http_params(parameters)}")
  end

  def convert_to_http_params(hash = {})
    hash.inject([]) { |memo, (key, value)| memo << "#{key.to_s}=#{value.to_s}" }.join('&')
  end

  #process the product
  def process_product(xml_doc, cat_name)
    p "begin process product!"
    #check if there exist product
    return unless xml_doc["items_get_response"]["items"].present?
    #guarantee there are more than 1 product on the page
    items = xml_doc["items_get_response"]["items"]["item"]
    return unless items.present?
    #if there is only one product
    items = [items] unless items.is_a?(Array)
    items.each do |prod|
      begin
        try do
          #parameters of http request
          time = Time.now
          parameters = {
              :timestamp => time.strftime("%Y-%m-%d %H:%M:%S"),
              :app_key => @config["key"],
              :method => "taobao.item.get",
              :partner_id => "top-apitools",
              :format => "xml",
              :fields => "desc",
              :sign_method => "md5",
              :v => "2.0",
              :num_iid => prod["num_iid"]
          }
          parameters[:sign] = ::Digest::MD5.hexdigest(@config["secret"] + parameters.sort.flatten.join + @config["secret"]).upcase
          #to replace the blank ' '
          parameters[:timestamp] = time.strftime("%Y-%m-%d+%H:%M:%S")
          #return the restful WS address
          uri = URI.parse("http://gw.api.taobao.com/router/rest?#{convert_to_http_params(parameters)}")
          response = Net::HTTP.get(uri)
          xml_doc = Crack::XML.parse(response)

          #get the name
          product_name = prod["title"]

          unless product_name.blank?
            #according to the name, either find the product from database or initialize a new one
            product = Product.find_or_initialize_by(name: product_name)
          end

          #get the price
          product.price = prod["price"]

          #find or new a vendor
          vendor = Vendor.find_or_initialize_by(name: prod["nick"])
          if vendor.new_record?
            #it's a vendor from Taobao Mall
            vendor.is_tmall = true
            vendor.save!
          end
          #set the vendor
          product.vendor = vendor

          product.description = xml_doc["item_get_response"]["item"]["desc"]

          #get the image
          pic_url = prod["pic_url"]
          if product.image.blank? || product.image.remote_picture_url != pic_url
            #we are using Carrierwave, so just set the remote_image_url, it will download the image for us
            pic = product.create_image(remote_picture_url: pic_url)
          end

          #initialize the tags of product
          product.tags=[]
          #get the tag
          product.tags = seg_word(product_name)

          product.catalogs = []
          #set the product catalog
          get_product_catalog(cat_name, product)

          #record the product
          if product.new_record?
            if product.valid?
              #everything is ok, save the new object to DB
              product.save!
              #calculate the product amount
              @product_count+=1
              p "Insert #{product.name} of tag: #{product.tags} of Catalogs: #{product.catalogs.all.to_a} from Taobao Mall"
              #p "Insert #{product.name} from Taobao Mall"
            else
              #p "Somethings goes wrong when save the product"
              p "Invalid #{product.errors.to_s} of #{product.url}"
            end
          else
            if product.changed?
              #update the change
              product.save!
              p "Update: #{product.name} of #{product.tags} of Catalogs: #{product.catalogs.all.to_a} from Taobao Mall"
              #p "Update: #{product.name} from Taobao Mall"
            end
          end
        end
      rescue StandardError => ex_msg
        p ex_msg
        break
      end
    end
  end

  def seg_word(word)
    words =[]
    algor = RMMSeg::Algorithm.new(word)
    loop do
      tok = algor.next_token
      break if tok.nil?
      if words.present?
        words.push(tok.text.force_encoding("UTF-8")) if @dic_words.include?(tok.text.force_encoding("UTF-8")) && !words.include?(tok.text.force_encoding("UTF-8"))
      else
        words.push(tok.text.force_encoding("UTF-8")) if @dic_words.include?(tok.text.force_encoding("UTF-8"))
      end
    end
    return words
  end

  def get_product_catalog(cat_name, product)
    try do
      # cat_tags is the set of segmented words of the catalog name from the site we spider
      cat_tags = seg_word(cat_name.split(":")[0])
      word = seg_word(product.name)
      @@cat_words.each do |(cat, cat_words)|
        cat_words.each do |cat_word|
          # foreach word in cat_words, check if it is related to the catalog from the site we spider
          # if it is related, set the product to corresponding catalog under our site
          if cat_tags.include?(cat_word)
            product.catalogs << cat unless product.catalogs.include?(cat)
          end
          # check if it is related to the segmented product tags from the site we spider
          # if it is related, set the product to corresponding catalog under our site
          if word.include?(cat_word)
            product.catalogs << cat unless product.catalogs.include?(cat)
          end
        end
      end
      if product.catalogs.size > 1
        catalogs ={}
        product.catalogs.each do |catalog|
          if catalogs[catalog.ancestry].present?
            catalogs[catalog.ancestry] = catalogs[catalog.ancestry].to_s + "," + catalog.id.to_s
          else
            catalogs[catalog.ancestry] = catalog.id.to_s
          end
        end
        catalogs.each do |(key, value)|
          cat_id = value.split(",")
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
            product.catalogs << Catalog.find(cat_id[0]) unless product.catalogs.include?(Catalog.find(cat_id[0]))
          end
        end
      end
    end
  end

end
