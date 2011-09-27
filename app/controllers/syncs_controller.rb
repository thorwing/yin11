#encoding utf-8
require 'crack/xml'

class SyncsController < ApplicationController
    before_filter(:only => [:follow_yin11, ]) { |c| c.require_permission :normal_user }

    def new
      client = OauthChina::Sina.new
      authorize_url = client.authorize_url
      Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
      redirect_to authorize_url
    end

    def callback
      client = OauthChina::Sina.load(Rails.cache.read(build_oauth_token_key(params[:type], params[:oauth_token])))
      client.authorize(:oauth_verifier => params[:oauth_verifier])
      Logger.new(STDOUT).info client.to_yaml

      user = sync_account(client)
      if user.present?
        flash[:notice] = t("notices.welcome_back", :name => user.screen_name)
      else
        flash[:notice] = t("syncs.access_failed")
      end

      redirect_to root_path
    end

    def follow_yin11
      client = OauthChina::Sina.load(:access_token => current_user.access_token, :access_token_secret => current_user.access_token_secret)
      xml = (client.access_token.post "/friendships/create/#{YIN11_SINA_WEIBO_ID}.xml").body
      Logger.new(STDOUT).info xml.to_s

      redirect_to root_path
    end

    private
    def build_oauth_token_key(name, oauth_token)
      [name, oauth_token].join("_")
    end

    def sync_account(client)
      results = client.dump

      if results[:access_token] && results[:access_token_secret]
        #access_token = OAuth::AccessToken.new(client.consumer, results[:access_token], results[:access_token_secret])
        xml = (client.access_token.get "/account/verify_credentials.xml").body
        credentials = Crack::XML.parse(xml)

        user = User.find_or_initialize_by(:provider => params[:type], :uid => credentials["user"]["id"])
        if user.new_record?
          user.provider = params[:type]
          user.uid = credentials["user"]["id"]
          user.login_name = credentials["user"]["screen_name"]
          user.access_token = results[:access_token]
          user.access_token_secret = results[:access_token_secret]
          user.save!
        end

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