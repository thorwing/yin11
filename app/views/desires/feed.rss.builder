xml.instruct! :xml, :version => "1.0"

base_url = 'http://' + request.host_with_port

xml.rss :version => "2.0" do #, "xmlns:media" => 'http://search.yahoo.com/mrss/'
  xml.channel do
    xml.title t("site.name")
    xml.description t("site.description")
    xml.link desires_url

    for desire in @desires
      xml.item do
        xml.title t("desires.desire")
        xml.media(:content, :url =>  base_url + desire.get_image_url(:thumb), :type => "image/jpeg")
        xml.description desire.content
        xml.pubDate desire.created_at.to_s(:rfc822)
        xml.link desire_url(desire)
        xml.guid desire_url(desire)
      end
    end
  end
end