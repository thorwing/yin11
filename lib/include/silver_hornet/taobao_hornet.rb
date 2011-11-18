#encoding utf-8
require 'crack/xml'

class SilverHornet::TaobaoHornet

  @@product_count ||=0

  def config
    @config ||= lambda do
      filename = "#{Rails.root}/config/silver_hornet/taobao.yml"
      file = File.open(filename)
      yaml = YAML.load(file)
      return yaml
    end.call
    @config
  end

  def fetch
    config
    #initialize a hash
    catalog={}
    #get the all subcatalogs on taobao from parent_cid, and make them into the hash pairs
    @config["parent_cid"].each { |parent_cid| catalog.merge!(fetch_catalog(parent_cid)) }
    #for each catalog, get the response xml file by posing a restful WS url, and then process the product on it
    catalog.each { |(key, value)| get_xml(1, 40, key, value) }
    #count the total product amount
    p "We've got #{@@product_count}' product!"
  end

  #get the all subcatalogs on taobao from parent_cid
  def fetch_catalog(parent_cid)
    catalog={}
    time = Time.now
    #parameters of http request
    parameters = {
        :timestamp => time.strftime("%Y-%m-%d %H:%M:%S"),
        :app_key => @config["key"],
        :method => "taobao.itemcats.get",
        :partner_id => "top-apitools",
        :format => "xml",
        :fields => "cid,name",
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
    response = Net::HTTP.get(uri)
    #make xml file into a hash
    xml_doc = Crack::XML.parse(response)
    if xml_doc.present?
      #for each subcatalog to process the products related to
      xml_doc["itemcats_get_response"]["item_cats"]["item_cat"].each { |cat| catalog[cat["cid"]]=cat["name"] }
    end
    return catalog
  end

  #get the response xml file by posing a restful WS url
  def get_xml(page_no, page_size, cid, cat_name)
    #get the restful WS url
    p "page_no: #{page_no}"
    uri = get_uri(page_no, page_size, cid)
    p uri
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
    #check if there exist product
    return unless xml_doc["items_get_response"]["items"].present?
    #guarantee there are more than 1 product on the page
    items = xml_doc["items_get_response"]["items"]["item"]
    return unless items.present?
    #if there is only one product
    items = [items] unless items.is_a?(Array)
    items.each do |prod|
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

      #get the image
      pic_url = prod["pic_url"]
      if product.image.blank? || product.image.remote_pictire_url != pic_url
        #we are using Carrierwave, so just set the remote_pictire_url, it will download the image for us
        pic = product.create_image(remote_pictire_url: pic_url)
      end

      #get the tag
      product.tags =[cat_name]

      #record the product
      if product.new_record?
        if product.valid?
          #everything is ok, save the new object to DB
          product.save!
          #calculate the product amount
          @@product_count+=1
          p "Insert #{product.name} of #{product.tags}"
        else
          p "somethings goes wrong"
          #p "Invalid #{product.errors.join} of #{product.url}"
        end
      else
        if product.changed?
          #update the change
          product.save!
          p "Update: #{product.name} of #{product.tags}"
        end
      end
    end

  end
end
