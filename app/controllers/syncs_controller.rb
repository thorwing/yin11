#encoding utf-8
require 'crack/xml'

class SyncsController < ApplicationController

    def new
      case params[:type]
        when "sina"
           client = SilverOauth::Sina.new
        when "douban"
           client = SilverOauth::Douban.new
        when "qq"
           client = SilverOauth::Qq.new
        when "sohu"
           client = SilverOauth::Sohu.new
        when "netease"
           client = SilverOauth::Netease.new
        when "taobao"
           client = SilverOauth::Taobao.new
        when "renren"
           client = SilverOauth::Renren.new
        else
          raise "Not support such third-party login method"
      end

      authorize_url = client.authorize_url
      Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
      redirect_to authorize_url
    end

    def callback
      site_name_mapping = {"sina" => "Sina", "douban" => "Douban", "qq" => "Qq", "sohu" => "Sohu", "netease" => "Netease", "taobao" => "Taobao", "renren" => "Renren" }

      site_name = site_name_mapping[params[:type]]
      client = eval("SilverOauth::#{site_name}").load(Rails.cache.read(build_oauth_token_key(params[:type], params[:oauth_token])))

      case params[:type]
      when "taobao"
          p = {
            'grant_type' => 'authorization_code',
            'code' => params[:code],
            'redirect_uri' => client.url,
            'client_id' => client.key,
            'client_secret' => client.secret
          }

          #use the returned "code" to retrieve the access_token
          uri = URI.parse("https://oauth.taobao.com/")
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          #request = Net::HTTP::Get.new(uri.request_uri)
          response, data  = http.post('/token', convert_to_http_params(p))

          @taobao_access_token = Crack::JSON.parse(response.body)["access_token"]
          #TODO an unexpected redirecting happens
          unless @taobao_access_token
            redirect_to root_path
            return
          end

          client.authorize_taobao(@taobao_access_token)
      when "renren"
          p = {
            'grant_type' => 'authorization_code',
            'code' => params[:code],
            'redirect_uri' => client.callback,
            'client_id' => client.key,
            'client_secret' => client.secret
          }

            #use the returned "code" to retrieve the access_token
          uri = URI.parse("https://graph.renren.com")
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          #request = Net::HTTP::Get.new(uri.request_uri)
          response, data  = http.post('/oauth/token', convert_to_http_params(p))

          @renren_access_token = Crack::JSON.parse(response.body)["access_token"]
          client.authorize_renren(@renren_access_token)

          #get session key
          p = {
            'oauth_token' => @renren_access_token
             }

          response, data  = http.post("https://graph.renren.com/renren_api/session_key" , convert_to_http_params(p))

          @renren_session_key = Crack::JSON.parse(response.body)["renren_token"]["session_key"]

        else

          client.authorize(:oauth_verifier => params[:oauth_verifier])

      end

      Logger.new(STDOUT).info client.to_yaml

      case params[:type]
        when "sina"
          response = (client.access_token.get "/account/verify_credentials.xml").body
        when "douban"
          if  client.access_token.nil?
            p "user reject authorization"
            redirect_to root_url
            return
          else
            response = (client.access_token.get "http://api.douban.com/people/%40me").body
          end
        when "qq"
          response = (client.access_token.get "http://open.t.qq.com/api/user/info?format=xml").body
        when "sohu"
          response = (client.access_token.get "http://api.t.sohu.com/users/show.xml").body
        when "netease"
          response = (client.access_token.get "http://api.t.163.com/users/show.json").body
          p "netease_response: " + response.to_yaml

        when "taobao"
          time = Time.now
          p = {
            :timestamp => time.strftime("%Y-%m-%d %H:%M:%S"),
            :app_key => client.key,
            :method => "taobao.user.get",
            :partner_id => "top-apitools",
            :format => "xml",
            :fields => "nick,uid",
            :sign_method => "md5",
            :v => "2.0",
            :session => @taobao_access_token
          }

          p[:sign] = ::Digest::MD5.hexdigest(client.secret + p.sort.flatten.join + client.secret).upcase
          #to replace the blank ' '
          p[:timestamp] = time.strftime("%Y-%m-%d+%H:%M:%S")

          uri = URI.parse("http://gw.api.taobao.com/router/rest?#{convert_to_http_params(p)}")
          response = (client.access_token.get uri.to_s).body

        when "renren"
            p = {
            :v => "=1.0",
            :api_key => "=" + client.key,
            :method => "=users.getInfo",
            :call_id => "=" + Time.now.tv_usec.to_s,
            :session_key =>  "=" + @renren_session_key
             }
          @to_be_md5 = p.sort.flatten.join + client.secret
          #p "@to_be_md5"  + @to_be_md5
          p[:sig] = "=" + ::Digest::MD5.hexdigest(@to_be_md5)
          #p "p[:sig]:" + p[:sig]


          uri = URI.parse("http://api.renren.com/restserver.do?#{p.inject([]){|memo, (key,value)| memo << "#{key.to_s}#{value.to_s}" }.join('&')}")
          #p "uri.to_s: "  + uri.to_s
          response = (client.access_token.post uri.to_s).body

        else
          raise "Not support such third-party login method"


      end

      user = sync_account(response, client)

      if user.present?
        flash[:notice] = t("notices.welcome_back", :name => user.screen_name)
      else
        flash[:notice] = t("syncs.access_failed")
      end

      redirect_to root_path
    end

    #def follow_yin11
    #  client = SilverOauth::Sina.load(:access_token => current_user.access_token, :access_token_secret => current_user.access_token_secret)
    #  if client && client.access_token
    #    xml = (client.access_token.post "/friendships/create/#{YIN11_SINA_WEIBO_ID}.xml").body
    #    #Logger.new(STDOUT).info xml.to_s
    #  end
    #
    #  redirect_to root_path
    #end

    private
    def convert_to_http_params(hash = {})
      hash.inject([]){|memo, (key,value)| memo << "#{key.to_s}=#{value.to_s}" }.join('&')
    end

    def build_oauth_token_key(name, oauth_token)
      [name, oauth_token].join("_")
    end

    def extract_user_info(credentials, results)
        case params[:type]
          when "sina"
            user = User.find_or_initialize_by(:provider => params[:type], :uid => credentials["user"]["id"])
            user.uid = credentials["user"]["id"]
            user.login_name = credentials["user"]["screen_name"]

          when "douban"
            user = User.find_or_initialize_by(:provider => params[:type], :uid => credentials["entry"]["db:uid"])
            user.uid = credentials["entry"]["db:uid"]
            user.login_name = credentials["entry"]["title"]

          when "qq"
            user = User.find_or_initialize_by(:provider => params[:type], :uid => credentials["root"]["data"]["name"])
            user.uid = credentials["root"]["data"]["name"]
            user.login_name = credentials["root"]["data"]["nick"]

          when "sohu"
            user = User.find_or_initialize_by(:provider => params[:type], :uid => credentials["user"]["id"])
            user.uid = credentials["user"]["id"]
            user.login_name = credentials["user"]["screen_name"]

          when "netease"
            user = User.find_or_initialize_by(:provider => params[:type], :uid => credentials["id"])
            user.uid = credentials["id"]
            user.login_name = credentials["name"]

          when "taobao"
            user = User.find_or_initialize_by(:provider => params[:type], :uid => credentials["user_get_response"]["user"]["uid"])
            user.uid = credentials["user_get_response"]["user"]["uid"]
            user.login_name = credentials["user_get_response"]["user"]["nick"]

          when "renren"
            user = User.find_or_initialize_by(:provider => params[:type], :uid => credentials["users_getInfo_response"]["user"]["uid"])
            user.uid = credentials["users_getInfo_response"]["user"]["uid"]
            user.login_name = credentials["users_getInfo_response"]["user"]["name"]
            p "uid" + user.uid
            p "login_name" + user.login_name
          else
            raise "Not support such third-party login method"
        end

         user.provider = params[:type]
         user.access_token = results[:access_token]
         user.access_token_secret = results[:access_token_secret]


         user.save! if user.new_record? || user.changed?



         user
    end

    def sync_account(response, client)
      #p "response: " + response.to_yaml
      results =  client.dump
      credentials = Crack::XML.parse(response)
      credentials = Crack::JSON.parse(response) if credentials.blank? # blanck = nil or " "
      #p "********************"
      #p credentials.to_yaml

      if results[:access_token] && results[:access_token_secret]
        user = extract_user_info(credentials, results)

        #TODO remember_me?
        if params[:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end

        user
      else
        nil
      end
    end

end