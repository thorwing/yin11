#encoding utf-8
require 'crack/xml'

class SyncsController < ApplicationController
    #before_filter(:only => [:follow_yin11, ]) { |c| c.require_permission :normal_user }

    def new
        case params[:type]
          when "sina"
             client = OauthChina::Sina.new
          when "douban"
             client = OauthChina::Douban.new
          when "qq"
             client = OauthChina::Qq.new
          when "sohu"
             client = OauthChina::Sohu.new
          when "netease"
             client = OauthChina::Netease.new
        end

        authorize_url = client.authorize_url
        Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
        redirect_to authorize_url
    end

    def callback
      site_name_mapping = {"sina" => "Sina", "douban" => "Douban", "qq" => "Qq", "sohu" => "Sohu", "netease" => "Netease" }

      site_name = site_name_mapping[params[:type]]
      client = eval("OauthChina::#{site_name}").load(Rails.cache.read(build_oauth_token_key(params[:type], params[:oauth_token])))
      client.authorize(:oauth_verifier => params[:oauth_verifier])
      Logger.new(STDOUT).info client.to_yaml

      case params[:type]
        when "sina"
          response = (client.access_token.get "/account/verify_credentials.xml").body
        when "douban"
          response = (client.access_token.get "http://api.douban.com/people/%40me").body
        when "qq"
          response = (client.access_token.get "http://open.t.qq.com/api/user/info?format=xml").body
        when "sohu"
          response = (client.access_token.get "http://api.t.sohu.com/users/show.xml").body
        when "netease"
          response = (client.access_token.get "http://api.t.163.com/users/show.json").body
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
    #  client = OauthChina::Sina.load(:access_token => current_user.access_token, :access_token_secret => current_user.access_token_secret)
    #  if client && client.access_token
    #    xml = (client.access_token.post "/friendships/create/#{YIN11_SINA_WEIBO_ID}.xml").body
    #    #Logger.new(STDOUT).info xml.to_s
    #  end
    #
    #  redirect_to root_path
    #end

    private
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

       end
       user.provider = params[:type]
       user.access_token = results[:access_token]
       user.access_token_secret = results[:access_token_secret]
       user.save! if user.new_record? || user.changed?

       user
    end

    def sync_account(response, client)
      results =  client.dump
      credentials = Crack::XML.parse(response)
      credentials = Crack::JSON.parse(response) if credentials.blank? # blanck = nil or " "
      p "Credentials is a " + credentials.class.name
      p credentials.to_yaml

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