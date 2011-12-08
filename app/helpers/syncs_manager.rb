class SyncsManager
  def initialize(user)
    @user = user
  end

  def sync(review)
    @status = false
    @user_message = I18n.t("syncs.failure_message") + I18n.t("syncs.sites.#{review.author.provider}")
    @message = review.content
    case review.author.provider
      when "douban"  #ok
        client = SilverOauth::Douban.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        @message = %Q{<?xml version='1.0' encoding='UTF-8'?><entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/"><content>#{@message.to_s}</content></entry>}
        response = client.access_token.post(client.add_blog_url, @message,{"Content-Type"=>"application/atom+xml"})
        if response.code == "201"
          @user_message = I18n.t("syncs.success_message") + I18n.t("syncs.sites.#{review.author.provider}")
          @status = true
        end

      #when "qq"  #with pic    not yet
      #  client = SilverOauth::Qq.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
      #  #response = client.access_token.request(:post, client.add_blog_url, :content => @message, :format => "xml")
      #  path = review.images.first.image.path.to_s
      #  binary_content = review.images.first.image.read
      #  #p "binary_content" + binary_content
      #  fake_file = SilverOauth::FakeFile.new(path, binary_content)
      #  #response = client.add_status("my message" + path)
      #  #p "qq_response1" + response.to_yaml
      #  response = client.upload_binary_image("my message2" + path, binary_content)
      #  p "qq_response2" + response.to_yaml
      #  if Crack::XML.parse(response.body)["root"]["msg"] == "ok"
      #    p "correctly send review to the qq_blog"
      #  else
      #    p "may not correctly send review to the qq_blog"
      #  end

      when "qq" #without pic ok
        client = SilverOauth::Qq.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        #client.add_status("ͬ����qq΢��..")
        url = "http://open.t.qq.com/api/t/add"
        message = [review.title, review.content].join(": ")
        response = client.access_token.request(:post, url, :content => message, :format => "xml")
        p "qq_response: " + response.to_yaml
      if Crack::XML.parse(response.body)["root"]["msg"] == "ok"
        @user_message = I18n.t("syncs.success_message") + I18n.t("syncs.sites.#{review.author.provider}")
        @status = true
      end

      when "taobao" #not yet

      when "renren" #implemented but not test
          p = {
            :v => "=1.0",
            :api_key => "=" + client.key,
            :method => "=blog.addBlog",
            :call_id => "=" + Time.now.tv_usec.to_s,
            :title => review.title,
            :content => review.content,
            :access_token => client.access_token
             }
          @to_be_md5 = p.sort.flatten.join + client.secret
          p[:sig] = "=" + ::Digest::MD5.hexdigest(@to_be_md5)
          uri = URI.parse("http://api.renren.com/restserver.do?#{p.inject([]){|memo, (key,value)| memo << "#{key.to_s}#{value.to_s}" }.join('&')}")
          #p "uri.to_s: "  + uri.to_s
          response = (client.access_token.post uri.to_s).body
          Logger.new(STDOUT).info response.to_yaml
          p "renren_response " + response.to_yaml

      else
        site_name_mapping = {"sina" => "Sina", "sohu" => "Sohu", "netease" => "Netease" }
        site_name = site_name_mapping[review.author.provider]
        client = eval("SilverOauth::#{site_name}").load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        #carrierwave
        unless review.images.first.nil?  #with pic
          path = review.images.first.picture.path.to_s
          binary_content = review.images.first.picture.read
          #p "binary_content" + binary_content
          fake_file = SilverOauth::FakeFile.new(path, binary_content)
          response = client.upload_binary_image(@message, fake_file)
        else #without pic
          response = client.add_status(@message)
        end

        if response.code == "200"
          #p "syncs.sites."+ review.author.provider
          @user_message = I18n.t("syncs.success_message") + I18n.t("syncs.sites.#{review.author.provider}")
          @status = true
          p "correctly send review to the " + site_name
        end
        #if Crack::JSON.parse(response.body)["text"] == @message
        #  p "correctly send review to the sohu_blog"
        #else
        #  p "may not correctly send review to the sohu_blog"
        #end

    end # end of case
    return @user_message, @status

  end

  #def post(path,data="",headers={})
  #  @access_token.post(path,data,headers)
  #end


  def following_yin11?
    client = SilverOauth::Sina.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
    xml = (client.access_token.get "/friendships/show.xml?target_id=#{YIN11_SINA_WEIBO_ID}").body
    results = Crack::XML.parse(xml)
    #Logger.new(STDOUT).info results.to_yaml

    boolean(results["relationship"]["target"]["followed_by"])
  end

  private
  def convert_to_http_params(hash = {})
    hash.inject([]){|memo, (key,value)| memo << "#{key.to_s}=#{value.to_s}" }.join('&')
  end

  #todo make it public to all(in kernel)
  def boolean(string)
    return true if string == true || string =~ /^true$/i
    return false if string == false || string.nil? || string =~ /^false$/i
    raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
  end
end