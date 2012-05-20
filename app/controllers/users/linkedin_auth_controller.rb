require 'linkedin'

class Users::LinkedinAuthController < ApplicationController
  before_filter :create_client

  def register
    request_token = @client.request_token(:oauth_callback => linkedin_connect_url)
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret
    session[:first]

    redirect_to @client.request_token.authorize_url
  end

  def callback
    @user = User.find(current_user.id)

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

    if ( @user.update_attribute(:linkedin_token, params[:oauth_token]) and
         @user.update_attribute(:linkedin_secret, params[:oauth_verifier]) and
         @user.update_attribute(:headline, @profile.headline) and sign_in @user)
      flash[:success] = "You have successfully connected with your LinkedIn account."
      redirect_to edit_user_path(@user.id)
    else
      logger.debug @user.errors.full_messages
      flash.now[:error] = "Could not connect with LinkedIn profile."
      render 'callback'
    end
  end

  private
    def create_client
      @client = LinkedIn::Client.new(Settings.linkedin.key, Settings.linkedin.secret)
    end
end
