require 'linkedin'

class LinkedinAuthController < ApplicationController
  before_filter :create_client

  def index
    request_token = @client.request_token(:oauth_callback => "http://#{request.host_with_port}/linkedin/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to @client.request_token.authorize_url
  end

  def callback
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = @client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      @client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @profile = @client.profile
    @connections = @client.connections
  end

  def create_client
    @client = LinkedIn::Client.new(Settings.linkedin.key, Settings.linkedin.secret)
  end
end
