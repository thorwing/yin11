#coding: utf-8

require 'crack/xml'
require 'rubygems'
require 'rmmseg'

class SilverHornet::TopHornet

  def initialize
    #initialize the Dictionary for word segmentation
    RMMSeg::Dictionary.add_dictionary("#{Rails.root}/lib/include/silver_hornet/dictionaries/silver.dic", :words)
    RMMSeg::Dictionary.load_dictionaries
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

  def dic_words
    words = Rails.cache.fetch('dic_words')
    if words.nil?
      words = []
      file = File.open("#{Rails.root}/lib/include/silver_hornet/dictionaries/silver.dic", "r")
      file.each_line do |line|
        word = line.split(" ")
        words.push(word[1])
      end
      file.close
      words = words.compact.uniq
      Rails.cache.write('dic_words', words, :expires_in => 3.hours)
    end

    words
  end

  def convert_to_http_params(hash = {})
    hash.inject([]) { |memo, (key, value)| memo << "#{key.to_s}=#{value.to_s}" }.join('&')
  end

  def extract_id(raw_url)
    id = nil
    begin
      url = URI.parse(raw_url)
      #TODO use regular expression
      if url && url.host.include?("taobao") || url.host.include?("tmall")
        if url.query
          parameters = CGI::parse(url.query)
          id = parameters["id"].first
        end
      end
    rescue StandardError => ex_msg
      p ex_msg
    end

    id
  end

  def fetch_product(url)
    product = nil
    id = extract_id(url)
    product = Product.first(conditions: {iid: id})

    if id.present? && product.nil?
      #try converting to taobaoke url
      product = convert_taobaoke(id)
      product = get_normal_item(id) unless product
    end

    return id.present?, product
  end

  def update_product(url, product)
      id = extract_id(url)
      if id.present?
        product = convert_taobaoke(id)
        product = get_normal_item(id) unless product && product.iid.present?
      end

      return id.present?, product
    end

  def send_query(parameters, retry_times = 3)
    response = nil

    time = Time.now
    parameters[:timestamp] = time.strftime("%Y-%m-%d %H:%M:%S")
    parameters[:sign] = ::Digest::MD5.hexdigest(config["secret"] + parameters.sort.flatten.join + config["secret"]).upcase
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

    response
  end

  def convert_taobaoke(id, product = nil)
    #parameters of http request, outer_code is optional, use it for backtrace
    response = send_query({
        method: "taobao.taobaoke.items.convert",
        format: "xml",
        app_key: config["key"],
        v: "2.0",
        sign_method: "md5",

        fields: "num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume",
        nick: config["nick"],
        num_iids: id,
        outer_code: "desire",
        is_mobile: false
    })

    #p "***response of taobaoke item: " + response
    xml_doc = Crack::XML.parse(response)
    if xml_doc["taobaoke_items_convert_response"].present?
      item = xml_doc["taobaoke_items_convert_response"]["taobaoke_items"]["taobaoke_item"]
      product = process_product(item, product)
    else
      nil
    end
  end

  def get_normal_item(id, product = nil)
    #parameters of http request, outer_code is optional, use it for backtrace
    response = send_query({
      method: "taobao.item.get",
      format: "xml",
      app_key: config["key"],
      v: "2.0",
      sign_method: "md5",

      fields: "num_iid,title,nick,pic_url,price,detail_url",
      nick: config["nick"],
      num_iid: id,
      outer_code: "desire",
      is_mobile: false
    })

    #p "***response of normal item: " + response
    xml_doc = Crack::XML.parse(response)
    if xml_doc["item_get_response"].present?
      item = xml_doc["item_get_response"]["item"]
      product = process_product(item, product)
    else
      nil
    end
  end

  #akei
  def process_product(item, product = nil)
    begin
      raise "item or num_iid is nil" unless (item && item["num_iid"].present?)

      #according to the name, either find the product from database or initialize a new one
      product = Product.new unless product
      product.iid = item["num_iid"]
      product.name = item["title"]
      product.refer_url = item["click_url"] if item["click_url"].present?
      product.normal_url = item["detail_url"] if item["detail_url"].present?
      product.price = item["price"]
      product.commission = item["commission"]
      product.commission_rate = item["commission_rate"]
      product.commission_num = item["commission_num"]
      product.commission_volume = item["commission_volume"]
      product.item_location = item["item_location"]
      product.volume = item["volume"]

      vendor = Vendor.find_or_initialize_by(name: item["nick"])
      vendor.url = item["shop_click_url"]
      vendor.seller_credit_score = item["seller_credit_score"]
      vendor.save if vendor.new_record? || vendor.changed?
      product.vendor = vendor

      #get the image
      pic_url = item["pic_url"]
      if product.image.blank? || product.image.remote_picture_url != pic_url
        #we are using Carrierwave, so just set the remote_image_url, it will download the image for us
        pic = product.create_image(remote_picture_url: pic_url)
      end

      #get the tag
      product.tags = seg_word(product.name).take(MAX_TAGS)

      #product.catalogs = []
      ##set the product catalog
      #get_product_catalog(cat_name, product)
      product.save! if product.new_record? || product.changed?
    rescue StandardError => ex_msg
      p ex_msg
      return nil
    end

    product
  end

  def seg_word(word)
    words =[]
    algor = RMMSeg::Algorithm.new(word)
    loop do
      tok = algor.next_token
      break if tok.nil?
      #words.push(tok.text.force_encoding("UTF-8")) if @dic_words.include?(tok.text.force_encoding("UTF-8")) && !words.include?(tok.text.force_encoding("UTF-8"))
      words.push(tok.text.force_encoding("UTF-8"))
    end

    return words.compact.uniq & dic_words
  end

end