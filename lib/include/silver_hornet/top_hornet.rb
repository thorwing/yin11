class SilverHornet::TopHornet

  def config
    @config ||= lambda do
      filename = "#{Rails.root}/config/silver_hornet/taobao.yml"
      file = File.open(filename)
      yaml = YAML.load(file)
      return yaml
    end.call
    @config
  end

  def convert_to_http_params(hash = {})
    hash.inject([]) { |memo, (key, value)| memo << "#{key.to_s}=#{value.to_s}" }.join('&')
  end

  def convert_url(url)
    product = nil
    #if url.include?("taobao") || url.include?("tmall")
    #
    #end

    id = "12471568877"

    retry_times = 3
    #parameters of http request
    #outer_code is optional, use it for backtrace
    time = Time.now
    parameters = {
        method: "taobao.taobaoke.items.convert",
        timestamp: time.strftime("%Y-%m-%d %H:%M:%S"),
        format: "xml",
        app_key: config["key"],
        v: "2.0",
        sign_method: "md5",

        fields: "num_iid,title,nick,pic_url,price,click_url,commission,ommission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume",
        nick: config["nick"], #"thorwing"
        #pid: "mm_30542523_0_0",
        num_iids: id,
        outer_code: "desire",
        is_mobile: false
    }
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

    xml_doc = Crack::XML.parse(response)
    xml_doc["taobaoke_items_convert_response"]["taobaoke_items"].each do |entry|
      item = entry[1]
      raise item["title"]
    end

  end

  def process_product(item)
    begin
      #check if there exist product
      return unless item.present?
      raise "Item's name is nil'" if item["num_iid"]

      #according to the name, either find the product from database or initialize a new one
      product = Product.find_or_initialize_by(iid: item["num_iid"])

      product.name = item["title"]
      #set the url
      product.url = item["click_url"]
      #get the price
      product.price = item["price"]
      #find or new a vendor
      @taobao ||= Mall.find_or_initialize_by(name: I18n.t("third_party.taobao"))
      if @taobao
        vendor = Vendor.find_or_initialize_by(name: ["nick"], mall_id: @taobao.id)
        vendor.url = item["shop_click_url"]
        vendor.save if vendor.new_record? || vendor.changed?
        product.vendor = vendor
      end

      #get the image
      pic_url = item["pic_url"]
      if product.image.blank? || product.image.remote_picture_url != pic_url
        #we are using Carrierwave, so just set the remote_image_url, it will download the image for us
        pic = product.create_image(remote_picture_url: pic_url)
      end

      #get the tag
      product.tags = seg_word(product.name)

      #product.catalogs = []
      ##set the product catalog
      #get_product_catalog(cat_name, product)

      product.save if product.new? || product.changed?
    rescue StandardError => ex_msg
      p ex_msg
      return
    end
  end

end