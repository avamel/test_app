class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
       auth = request.env["omniauth.auth"]
    #raise request.env["omniauth.auth"].to_yaml
    if auth.info.email.present?
      user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
      if user.persisted?
        sign_in_and_redirect user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.user_attributes"] = user.attributes
        redirect_to new_user_registration_url
      end
    else
      redirect_to new_user_registration_url, alert: 'Sorry, but we need access to information about your email. Please open it, or use another service for registration!'
    end
  end

  def twitter
    user = User.find_for_twitter_oauth(request.env["omniauth.auth"])
    if user.persisted?
      sign_in_and_redirect user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    user = User.find_for_google_oauth2(request.env["omniauth.auth"])
    if user.persisted?
      sign_in_and_redirect user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

end
