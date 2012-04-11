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

  def extract_id(raw_url)
    id = nil
    begin
      url = URI.parse(raw_url)
      #TODO use regular expression
      if url && url.host.include?("lashou.com")
        return "lashou", url.match(/deal[0-9]html/).captures
      end
    rescue StandardError => ex_msg
      p ex_msg
    end

    id
  end

  def fetch_tuan(url)
    tuan = nil
    website, identity = extract_id(url)
    tuan = Tuan.first(conditions: {url: url})

    #if identity.present? && tuan.nil?
    #  tuan = get_tuan(website, id)
    #end

    return tuan.present?, tuan
  end

  def fetch_all_tuans(website)
    #return the restful WS address
    urls = config[website]["urls"]
    urls.each do |url|
      p "Dealing " + website + " : " + url

      uri = URI.parse(url)

      response = Net::HTTP.get(uri)
      #p "***response of tuan: " + response
      xml_doc = Crack::XML.parse(response)

      tuan = nil

      case website
        when "lashou"
          url_items = xml_doc["urlset"]["url"]
          url_items.each do |url_item|
              tuan = handle_lashou(url_item)
          end
        when "meituan"
          url_items = xml_doc["response"]["deals"]["data"]
          url_items.each do |url_item|
            tuan = handle_meituan(url_item)
          end
        when "nuomi"
          url_items = xml_doc["urlset"]["url"]
          url_items.each do |url_item|
            tuan = handle_nuomi(url_item)
          end
        when "ftuan"
          url_items = xml_doc["urlset"]["url"]
          url_items.each do |url_item|
            tuan = handle_ftuan(url_item)
          end
      end
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

      retry_times = 3
      #begin
      #  pic_url = item["image"]
      #  if tuan.image.blank? || tuan.image.remote_picture_url != pic_url
      #    #we are using Carrierwave, so just set the remote_image_url, it will download the image for us
      #    tuan.create_image(remote_picture_url: pic_url)
      #  end
      #rescue StandardError => ex_msg
      #  p ex_msg
      #  retry if (retry_times -= 1) > 0
      #end
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
      #retry_times = 3
      #begin
      #  pic_url = item["deal_img"]
      #  if tuan.image.blank? || tuan.image.remote_picture_url != pic_url
      #    #we are using Carrierwave, so just set the remote_image_url, it will download the image for us
      #    tuan.create_image(remote_picture_url: pic_url)
      #  end
      #rescue StandardError => ex_msg
      #  p ex_msg
      #  retry if (retry_times -= 1) > 0
      #end
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

      retry_times = 3
      #begin
      #  pic_url = item["image"]
      #  if tuan.image.blank? || tuan.image.remote_picture_url != pic_url
      #    #we are using Carrierwave, so just set the remote_image_url, it will download the image for us
      #    tuan.create_image(remote_picture_url: pic_url)
      #  end
      #rescue StandardError => ex_msg
      #  p ex_msg
      #  retry if (retry_times -= 1) > 0
      #end
    end

    if tuan && (tuan.new_record? || tuan.changed?)
      tuan.save!
      p "saved " + tuan.name
    end
  end

  def handle_ftuan(xml_node)
    tuan = nil
    item = xml_node["data"]["display"]

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

    if tuan && (tuan.new_record? || tuan.changed?)
      tuan.save!
      p "saved " + tuan.name
    end
  end

end