xml.instruct! :xml, :version => "1.0"

base_url = 'http://' + request.host_with_port

xml.rss :version => "2.0" do #, "xmlns:media" => 'http://search.yahoo.com/mrss/' do
  xml.channel do
    xml.title t("site.name")
    xml.description t("site.description")
    xml.link base_url

    for desire in @desires
      xml.item do
        xml.title truncate_content(desire.content, 20)
        #xml.media(:thumbnail, :url =>  base_url + desire.get_image_url(:thumb), widht: 75, height: 75)
        # qq_mail is 180 * 130
        xml.description { xml.cdata!("<p><img width=#{"120"} height=#{"120"} alt=#{'"' + t("desires.desire") + '"'} src=#{'"' + base_url + desire.get_image_url(:thumb) + '"'} ></p><p>#{desire.content}</p>") }
        #xml.description desire.content
        xml.pubDate desire.created_at.to_s(:rfc822)
        xml.link desire_url(desire)
        xml.guid desire_url(desire)
      end
    end
  end
end