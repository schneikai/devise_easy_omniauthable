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

  protected
    # The path used after sign up via omniauth. You need to overwrite this
    # method in your own OmniauthCallbacksController.
    def after_sign_up_path_for(resource)
      after_sign_in_path_for(resource)
    end

    def handle_provider(name)
      omni = request.env["omniauth.auth"]
      provider = DeviseEasyOmniauthable::Providers.find_by_name(name)

      # First try to find a user with a authentication matching the provider and
      # uid. If found sign that user in. It might be possible that another
      # user is currently signed in here. In that case the current user is signed
      # out and the other user becomes the current user. That way we make sure
      # that a provider and uid combination matches only one user..
      resource = resource_class.find_for_omniauth(omni['provider'], omni['uid'])

      if resource
        sign_in resource
        redirect_to after_sign_in_path_for(resource), notice: I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)

      elsif user_signed_in?
        current_user.create_or_update_authentication!(omni)
        redirect_to after_sign_in_path_for(current_user), notice: I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)

      elsif (email = omni['extra']['raw_info'].email).present? && resource = resource_class.find_for_omniauth_by_email(email)
        resource.create_or_update_authentication!(omni)

        sign_in resource
        redirect_to after_sign_in_path_for(resource), notice: I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)

      else
        resource = resource_class.new
        resource.apply_omniauth(omni)
        resource.skip_confirmation! # TODO: Make this configurable?

        if resource.save
          sign_in resource
          redirect_to after_sign_up_path_for(resource), notice: I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)
        else
          # The user couldn't be created. Most probably the omniauth data
          # didn't have all the required information. Like for example Twitter
          # is not sending email addresses. We need to ask the user to provide
          # the missing details.
          session[:omniauth] = omni.except('extra')
          redirect_to new_user_registration_path, notice: I18n.t('devise.omniauth_callbacks.provide_missing_details')
        end
      end
    end
end
