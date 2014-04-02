class DeviseEasyOmniauthable::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    handle_provider :twitter
  end

  def facebook
    handle_provider :facebook
  end

  def google_oauth2
    handle_provider :google_oauth2
  end

  def github
    handle_provider :github
  end

  private
    def handle_provider(name)
      omni = request.env["omniauth.auth"]
      provider = DeviseEasyOmniauthable::Providers.find_by_name(name)
      authentication = DeviseEasyOmniauthable::Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])

      if authentication
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)
        sign_in_and_redirect authentication.authenticatable

      elsif user_signed_in?
        current_user.create_or_update_authentication!(omni)

        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)
        sign_in_and_redirect current_user

      elsif omni['extra']['raw_info'].email.present? && User.find_by_email(omni['extra']['raw_info'].email)
        user = User.find_by_email(omni['extra']['raw_info'].email)

        user.create_or_update_authentication!(omni)

        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)
        sign_in_and_redirect user

      else
        user = User.new
        user.apply_omniauth(omni)

        if user.save
          flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)
          sign_in_and_redirect User.find(user.id)
        else
          # The user couldn't be created. Most probably the omniauth data
          # didn't have all the required information. Like for example Twitter
          # is not sending email addresses. We need to ask the user to provide
          # the missing details.
          session[:omniauth] = omni.except('extra')
          flash[:notice] = I18n.t('devise.omniauth_callbacks.provide_missing_details')
          redirect_to new_user_registration_path
        end
      end
    end
end
