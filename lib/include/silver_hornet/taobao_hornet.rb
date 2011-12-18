#coding: utf-8

require 'crack/xml'
require 'rubygems'
require 'rmmseg'

class SilverHornet::TaobaoHornet

  #@@cat_words ||={}
  @@catalogs||=[]
  @@fetch_log ||={}

  def initialize

    @product_count=0

    @@fetch_log = {}

    #load_fetch_log
    load_fetch_log


    #initialize the taobao fetch config
    config

    #initialize the Dictionary for word segmentation
    RMMSeg::Dictionary.add_dictionary("#{Rails.root}/lib/include/silver_hornet/dictionaries/silver.dic", :words)
    RMMSeg::Dictionary.load_dictionaries

    #load the words related to food
    load_food_word

    #load the catalogs
    load_catalogs

    #load_fetch_log
    load_fetch_log

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
    @@catalogs = []
    Catalog.all.each do |cat|
      @@catalogs << cat
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

  def write_fetch_log(page_no, cid)
    if @@fetch_log[cid].present?
      @@fetch_log[cid] = @@fetch_log[cid].to_s + "," + page_no
    else
      @@fetch_log[cid] = page_no
    end

    file = File.open("#{Rails.root}/tmp/fetch_log.log", "w+")
    @@fetch_log.each{|key,value| file.puts(key.to_s + ":" +value.to_s)}
    file.close
  end

  def load_fetch_log
    if File.exist?("#{Rails.root}/tmp/fetch_log.log")
      file = File.open("#{Rails.root}/tmp/fetch_log.log", "r")
      file.each_line do |line|
        result = line.split(":")
        @@fetch_log[result[0]] = result[1]
      end
    else
      file = File.new("#{Rails.root}/tmp/fetch_log.log", "w")
    end
    file.close
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
    retry_times = 3
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
    retry_times = 3
    if @@fetch_log.present? && @@fetch_log.has_key?(cid)
      begin
        page_no = @@fetch_log[cid].split(",").last.to_i + 1
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
        write_fetch_log(page_no.to_s, cid.to_s)
        if page_no<=total_no
          get_xml(page_no, page_size, cid, cat_name)
        end
      rescue StandardError => ex_msg
        p ex_msg
        retry if (retry_times -= 1) > 0
      end
    else
      begin
        p "page_no: #{page_no}"
        uri = get_uri(page_no, page_size, cid)
        #get the response xml file
        response = Net::HTTP.get(uri)
        xml_doc = Crack::XML.parse(response)
        #process the product info on xml file
        process_product(xml_doc, cat_name)
        #count the page number
        total_no=(xml_doc["items_get_response"]["total_results"].to_i/page_size).to_i+1
        write_fetch_log(page_no.to_s, cid.to_s)
        if page_no<=total_no
          page_no+=1
          get_xml(page_no, page_size, cid, cat_name)
        end
      rescue StandardError => ex_msg
        p ex_msg
        retry if (retry_times -= 1) > 0
      end
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
    p "Products url: #{uri}"
  end

  def convert_to_http_params(hash = {})
    hash.inject([]) { |memo, (key, value)| memo << "#{key.to_s}=#{value.to_s}" }.join('&')
  end

  #process the product
  def process_product(xml_doc, cat_name)
    begin
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
                :fields => "detail_url", #desc
                :sign_method => "md5",
                :v => "2.0",
                :num_iid => prod["num_iid"]
            }
            parameters[:sign] = ::Digest::MD5.hexdigest(@config["secret"] + parameters.sort.flatten.join + @config["secret"]).upcase
            #to replace the blank ' '
            parameters[:timestamp] = time.strftime("%Y-%m-%d+%H:%M:%S")
            #return the restful WS address
            uri = URI.parse("http://gw.api.taobao.com/router/rest?#{convert_to_http_params(parameters)}")
            p "product url: #{uri}"
            response = Net::HTTP.get(uri)
            xml_doc = Crack::XML.parse(response)

            #get the name
            product_name = prod["title"]

            unless product_name.blank?
              #according to the name, either find the product from database or initialize a new one
              product = Product.find_or_initialize_by(name: product_name)
            end

            #set the url
            product.url = xml_doc["item_get_response"]["item"]["detail_url"]

            #get the price
            product.price = prod["price"]

            #find or new a vendor
            @taobao ||= Mall.first(conditions: {name: I18n.t("third_party.taobao")})
            vendor = Vendor.find_or_initialize_by(name: prod["nick"], mall_id: @taobao.id)
            if vendor.new_record?
              #it's a vendor from Taobao Mall
              vendor.is_tmall = true
              vendor.save!
            end
            #set the vendor
            product.vendor = vendor

            #set the description (html)
            #product.description = xml_doc["item_get_response"]["item"]["desc"]

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
                #p "Insert #{product.name} of tag: #{product.tags} of Catalogs: #{product.catalogs.all.to_a} from Taobao Mall"
                p "Insert #{product.name} from Taobao Mall"
              else
                #p "Somethings goes wrong when save the product"
                p "Invalid #{product.errors.to_s} of #{product.url}"
              end
            else
              if product.changed?
                #update the change
                product.save!
                #p "Update: #{product.name} of #{product.tags} of Catalogs: #{product.catalogs.all.to_a} from Taobao Mall"
                p "Update: #{product.name} from Taobao Mall"
              end
            end
          end
        rescue StandardError => ex_msg
          p ex_msg
          next
        end
      end
    rescue StandardError => ex_msg
      p ex_msg
      return
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
      cat_tags = seg_word(cat_name)
      product_words = seg_word(product.name)

      @@catalogs.each do |cat|
        cat_words = seg_word(cat.name)
        cat_words |= cat.alias_name if cat.alias_name.present?

        (cat_words & cat_tags).each do |cat_word|
          #assign catalog to product
          product.catalogs << cat unless product.catalogs.include?(cat)
          #loop through those child catalog that is not assigned to the product yet
          cat.children.reject{|c| product.catalogs.include?(c) }.each do |child|
            if product_words.include?(child.name)
              product.catalogs << child
              break
            elsif child.alias_name.present? && child.alias_name.select{|a| product_words.include?(a)}.size > 0
              product.catalogs << child
              break
            end
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
          cat_ids = value.split(",").uniq
          if cat_ids.size > 1
            cat_ids.each do |id|
              catalog = Catalog.find(id)
              words = seg_word(catalog.name)
              words |= catalog.alias_name if catalog.alias_name.present?
              is_related = words.select{|w| product_words.include?(w)}.size > 0
              product.catalogs.delete(catalog)  unless is_related
            end
          elsif product.catalogs.size < 1
            product.catalog_ids << cat_ids.first unless product.catalog_ids.include?(cat_ids.first)
          end
        end
      end
    end
  end

  #def get_product_catalog(cat_name, product)
  #  begin
  #    try do
  #      cat_tags = seg_word(cat_name)
  #      @@catalogs.each do |cat|
  #        cat_words=[]
  #        if cat.alias_name.present?
  #          cat_words=cat.alias_name | seg_word(cat.name)
  #        else
  #          cat_words = seg_word(cat.name)
  #        end
  #        cat_words.each do |cat_word|
  #          if cat_tags.include?(cat_word)
  #            product.catalogs << cat unless product.catalogs.include?(cat)
  #            if cat.children.present?
  #              cat.children.all.each do |child|
  #                unless product.catalogs.include?(child)
  #                  if seg_word(product.name).include?(child.name)
  #                    product.catalogs << child
  #                    break
  #                  else
  #                    if child.alias_name.present?
  #                      child.alias_name.each do |alias_name|
  #                        if seg_word(product.name).include?(alias_name)
  #                          product.catalogs << child
  #                          break
  #                        end
  #                      end
  #                    end
  #                  end
  #                else
  #                  break
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #      if product.catalogs.size > 1
  #        word = seg_word(product.name)
  #        catalogs ={}
  #        product.catalogs.each do |catalog|
  #          if catalogs[catalog.ancestry].present?
  #            catalogs[catalog.ancestry] = catalogs[catalog.ancestry].to_s + "," + catalog.id.to_s
  #          else
  #            catalogs[catalog.ancestry] = catalog.id.to_s
  #          end
  #        end
  #        catalogs.each do |(key, value)|
  #          cat_id = value.split(",").uniq
  #          if cat_id.size > 1
  #            cat_id.each do |id|
  #              is_related = false
  #              if Catalog.find(id).alias_name.present?
  #                words = Catalog.find(id).alias_name | seg_word(Catalog.find(id).name)
  #                words.each do |w|
  #                  if word.include?(w)
  #                    is_related = true
  #                  end
  #                end
  #              else
  #                words = seg_word(Catalog.find(id).name)
  #                words.each do |w|
  #                  if word.include?(w)
  #                    is_related = true
  #                  end
  #                end
  #              end
  #              unless is_related
  #                product.catalogs.delete(Catalog.find(id))
  #              end
  #            end
  #          end
  #          if product.catalogs.size < 1
  #            product.catalogs << Catalog.find(cat_id[0]) unless product.catalogs.include?(Catalog.find(cat_id[0]))
  #          end
  #        end
  #      end
  #    end
  #  rescue StandardError => ex_msg
  #    p ex_msg
  #    return
  #  end
  #end

end
