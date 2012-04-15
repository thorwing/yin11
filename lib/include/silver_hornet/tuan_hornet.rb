#coding: utf-8

class SilverHornet::TuanHornet

  def config
    @config ||= lambda do
      filename = "#{Rails.root}/config/silver_hornet/tuan.yml"
      file = File.open(filename)
      yaml = YAML.load(file)
      return yaml
    end.call
    @config
  end

  def extract_info(raw_url)
    website = nil
    city =nil
    url = URI.parse(raw_url)

    websites = config["websites"].map{|k,v| k}
    websites.each do |w|
      website = w if url && url.host.include?(w)
    end

    cities = config["cities"]
    cities.each do |c, city_names|
      city_names.each do |city_name|
        city = c if url && url.host.include?(city_name + ".")
      end
    end

    return website, city
  end

  def fetch_tuan(raw_url)
    #website, url = extract(raw_url)
    #p "Dealing raw_url: " + raw_url
    raw_url = raw_url.split('?')[0]
    #p "After processed url: " + raw_url
    website, city = extract_info(raw_url)
    if website && city
      tuan = Tuan.first(conditions: {url: raw_url})

      if tuan.nil?
        fetch_all_tuans(website, city)
        tuan = Tuan.first(conditions: {url: raw_url})
      end
    end

    return tuan
  end

  def fetch_all_tuans(website, city)
    begin
      p "Dealing " + website + " city " +  city

      #return the restful WS address
      url = config["websites"][website]["urls"][city]
      uri = URI.parse(url)

      response = Net::HTTP.get(uri)
      #p "***response of " + website + " city " +  city + ": " + response
      xml_doc = Crack::XML.parse(response)

      case website
        when "lashou"
          url_items = xml_doc["urlset"]["url"]
          url_items.each do |url_item|
            handle_lashou(url_item)
          end
        when "meituan"
          url_items = xml_doc["response"]["deals"]["data"]
          url_items.each do |url_item|
            handle_meituan(url_item)
          end
        when "nuomi"
          url_items = xml_doc["urlset"]["url"]
          url_items.each do |url_item|
            handle_nuomi(url_item)
          end
        #when "ftuan"
        #  url_items = xml_doc["urlset"]["url"]
        #  url_items.each do |url_item|
        #    handle_ftuan(url_item)
        #  end
      end
    rescue StandardError => ex_msg
      p ex_msg
    end
  end

  def handle_lashou(xml_node)
    tuan = nil
    item = xml_node["data"]["display"]
    if item["cate"] == "美食"
      tuan = Tuan.find_or_initialize_by(url: xml_node["loc"])
      tuan.website = item["website"]
      tuan.identity = item["gid"]
      tuan.name = item["title"]
      tuan.price = item["price"].to_f
      tuan.value = item["value"].to_f
      tuan.rebate = item["rebate"].to_f
      tuan.city = item["city"]
      tuan.start_time = Time.at(item["startTime"].to_i)
      tuan.end_time = Time.at(item["endTime"].to_i)

      tuan.image_url = item["image"]
    end

    if tuan && (tuan.new_record? || tuan.changed?)
      tuan.save!
      p "saved " + tuan.name
    end
  end

  def handle_meituan(xml_node)
    tuan = nil
    item = xml_node["deal"]
    if item["deal_cate"] == "餐饮"
      tuan = Tuan.find_or_initialize_by(url: item["deal_url"])
      tuan.website = item["website"]
      tuan.identity = item["deal_id"]
      tuan.name = item["deal_title"]
      tuan.price = item["price"].to_f
      tuan.value = item["value"].to_f
      tuan.rebate = item["rebate"].to_f
      tuan.city = item["city_name"]
      tuan.start_time = Time.at(item["start_time"].to_i)
      tuan.end_time = Time.at(item["end_time"].to_i)

      tuan.image_url = item["deal_img"]
    end

    if tuan && (tuan.new_record? || tuan.changed?)
      tuan.save!
      p "saved " + tuan.name
    end
  end

  def handle_nuomi(xml_node)
    tuan = nil
    item = xml_node["data"]["display"]
    if item["category"] == "1"
      tuan = Tuan.find_or_initialize_by(url: xml_node["loc"])
      tuan.website = item["website"]
      tuan.name = item["title"]
      tuan.price = item["price"].to_f
      tuan.value = item["value"].to_f
      tuan.rebate = item["rebate"].to_f
      tuan.city = item["city"]
      tuan.start_time = Time.at(item["startTime"].to_i)
      tuan.end_time = Time.at(item["endTime"].to_i)

      tuan.image_url = item["image"]

    end

    if tuan && (tuan.new_record? || tuan.changed?)
      tuan.save!
      p "saved " + tuan.name
    end
  end

  #def handle_ftuan(xml_node)
  #  tuan = nil
  #  item = xml_node["data"]["display"]
  #
  #  tuan = Tuan.find_or_initialize_by(url: xml_node["loc"])
  #  tuan.website = item["website"]
  #  tuan.name = item["title"]
  #  tuan.price = item["price"].to_f
  #  tuan.value = item["value"].to_f
  #  tuan.rebate = item["rebate"].to_f
  #  tuan.city = item["city"]
  #  tuan.start_time = Time.at(item["startTime"].to_i)
  #  tuan.end_time = Time.at(item["endTime"].to_i)
  #
  #  tuan.image_url = item["image"]
  #
  #  if tuan && (tuan.new_record? || tuan.changed?)
  #    tuan.save!
  #    p "saved " + tuan.name
  #  end
  #end

end