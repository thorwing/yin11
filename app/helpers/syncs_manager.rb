class SyncsManager
  def initialize(user)
    @user = user
  end

  def sync(review)
    case review.author.provider
      when "sina"
        client = SilverOauth::Sina.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        #client.add_status("同步到新浪微薄..")
        url = "http://api.t.sina.com.cn/statuses/update.xml"
        message = [review.title, review.content].join(": ")
        response = client.access_token.request(:post, url, :status => message)
        #Logger.new(STDOUT).info response.to_yaml
      when "douban"

      when "qq"  #without pic
        client = SilverOauth::Qq.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
        #client.add_status("同步到qq微薄..")
        url = "http://open.t.qq.com/api/t/add"
        message = [review.title, review.content].join(": ")
        response = client.access_token.request(:post, url, :content => message, :format => "xml")
        p "qq_response: " + response.to_yaml
        if Crack::XML.parse(response.body)["root"]["msg"] == "ok"
          p "correctly send review to the third party"
        end

      #when "qq" #with pic
      #  client = SilverOauth::Qq.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
      #  #client.add_status("同步到qq微薄..")
      #  url = "http://open.t.qq.com/api/t/add_pic"
      #  message = [review.title, review.content].join(": ")
      #  response = client.access_token.request(:post, url, :content => message, :format => "xml", :enctype=> "multipart/form-data", :pic => review.images.first.remote_picture_url, :type => "file")
      #  p "qq_response: " + response.to_yaml

      else

    end

  end

  def following_yin11?
    client = SilverOauth::Sina.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
    xml = (client.access_token.get "/friendships/show.xml?target_id=#{YIN11_SINA_WEIBO_ID}").body
    results = Crack::XML.parse(xml)
    #Logger.new(STDOUT).info results.to_yaml

    boolean(results["relationship"]["target"]["followed_by"])
  end

  private

  #todo make it public to all(in kernel)
  def boolean(string)
    return true if string == true || string =~ /^true$/i
    return false if string == false || string.nil? || string =~ /^false$/i
    raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
  end
end