module SilverOauth
  class Taobao < SilverOauth::OAuth

    def initialize(*args)
      self.consumer_options = {
        :site               => 'https://oauth.taobao.com/',
        :request_token_path => 'token',
        :access_token_path  => 'token',
        :authorize_path     => 'authorize',
        :realm              => url
      }
      super(key, secret)
    end

    def name
      :taobao
    end

    def authorized?
      #TODO
    end

    def destroy
      #TODO
    end

    def authorize_url
      @authorize_url = request_token.authorize_url(:response_type => "code", :client_id => key, :redirect_uri => callback)
    end

    def add_status(content, options = {})
      #options.merge!(:status => content)
      #self.post("http://api.t.sina.com.cn/statuses/update.json", options)
    end


    def upload_image(content, image_path, options = {})
      #options = options.merge!(:status => content, :pic => File.open(image_path, "rb")).to_options
      #upload("http://api.t.sina.com.cn/statuses/upload.json", options)
    end

  end
end