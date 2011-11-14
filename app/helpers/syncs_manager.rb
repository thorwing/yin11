class SyncsManager
  def initialize(user)
    @user = user
  end

  def sync(review)
    @message = [review.title, review.content].join(": ")
    case review.author.provider
      when "sina"  #ok
        client = SilverOauth::Sina.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        p "path " + review.images.first.image.path.to_s
        #carrierwave
        path = review.images.first.image.path.to_s
        binary_content = review.images.first.image.read
        fake_file = SilverOauth::FakeFile.new(path, binary_content)
        #response = client.silver_upload_image(@message, {:filename => "test.jpg", :content => review.images.first.image.read})
        response = client.upload_binary_image(@message, fake_file)
        #p "sina_response2 " + response.to_yaml
        if response.code == "200"
          p "correctly send review to the sina_blog"
        else
          p "may not correctly send review to the sina_blog"
        end

      when "douban"  #ok
        client = SilverOauth::Douban.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        @message = %Q{<?xml version='1.0' encoding='UTF-8'?><entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/"><content>#{@message.to_s}</content></entry>}
        response = client.access_token.post(client.add_blog_url, @message,{"Content-Type"=>"application/atom+xml"})
        if response.code == "201"
          p "correctly send review to the qq_blog"
        else
          p "may not correctly send review to the qq_blog"
        end

      when "qq"  #without pic    ok
        client = SilverOauth::Qq.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        response = client.access_token.request(:post, client.add_blog_url, :content => @message, :format => "xml")
        if Crack::XML.parse(response.body)["root"]["msg"] == "ok"
          p "correctly send review to the qq_blog"
        else
          p "may not correctly send review to the qq_blog"
        end

      when "netease"  #ok
        client = SilverOauth::Netease.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        response = client.access_token.request(:post, client.add_blog_url, :status => @message)
        if response.code == "200"
          p "correctly send review to the netease_blog"
        else
          p "may not correctly send review to the netease_blog"
        end

      when "sohu" #ok
        client = SilverOauth::Sohu.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        response = client.access_token.request(:post, client.add_blog_url, :status => @message )
        if Crack::JSON.parse(response.body)["text"] == @message
          p "correctly send review to the sohu_blog"
        else
          p "may not correctly send review to the sohu_blog"
        end

      when "taobao" #not yet


      when "renren" #not yet
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

      #when "qq" #with pic
      #  client = SilverOauth::Qq.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
      #  #client.add_status("同步到qq微薄..")
      #  url = "http://open.t.qq.com/api/t/add_pic"
      #  message = [review.title, review.content].join(": ")
      #  response = client.access_token.request(:post, url, :content => message, :format => "xml", :enctype=> "multipart/form-data", :pic => review.images.first.remote_image_url, :type => "file")
      #  p "qq_response: " + response.to_yaml

      else

    end

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