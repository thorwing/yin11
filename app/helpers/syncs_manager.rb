class SyncsManager
  def initialize(user)
    @user = user
  end

  def sync(review)
    client = OauthChina::Sina.load(:access_token => @user.access_token, :access_token_secret => @user.access_token_secret)
    #client.add_status("同步到新浪微薄..")
    url = "http://api.t.sina.com.cn/statuses/update.xml"
    message =truncate_content([review.title, review.content].join(": "), 140)
    response = client.access_token.request(:post, url, :status => message)
    #Logger.new(STDOUT).info response.to_yaml
  end
end