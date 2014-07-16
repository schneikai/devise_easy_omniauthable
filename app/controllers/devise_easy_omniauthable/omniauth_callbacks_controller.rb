class DeviseEasyOmniauthable::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Skip :verify_authenticity_token to make sure your session doesn't get reset
  # when the token verification fails. The OpenID server never sends it.
  # https://github.com/plataformatec/devise/issues/2432
  # skip_before_filter :verify_authenticity_token

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
    # Build a devise resource passing in the session. Useful to move
    # temporary session data to the newly created user.
    def build_resource(hash=nil)
      self.resource = resource_class.new_with_session(hash || {}, session)
    end

    # Signs in a user on sign up. You can overwrite this method in your own
    # OmniauthCallbacksController.
    def sign_up(resource_name, resource)
      sign_in(resource_name, resource)
    end

    # The path used after sign up via omniauth. You need to overwrite this
    # method in your own OmniauthCallbacksController.
    def after_sign_up_path_for(resource)
      after_sign_in_path_for(resource)
    end

    def handle_provider(name)
      omniauth_data = request.env["omniauth.auth"]
      provider = DeviseEasyOmniauthable::Providers.find_by_name(name)

      # First try to find a user with a authentication matching the provider and
      # uid. If found sign that user in. It might be possible that another
      # user is currently signed in here. In that case the current user is signed
      # out and the other user becomes the current user. That way we make sure
      # that a provider and uid combination matches only one user..
      self.resource = resource_class.find_for_omniauth(omniauth_data['provider'], omniauth_data['uid'])

      if resource
        sign_in resource
        redirect_to after_sign_in_path_for(resource), notice: I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)

      elsif user_signed_in?
        current_user.create_or_update_authentication!(omniauth_data)
        redirect_to after_sign_in_path_for(current_user), notice: I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)

      elsif (email = omniauth_data['extra']['raw_info'].email).present? && self.resource = resource_class.find_for_omniauth_by_email(email)
        resource.create_or_update_authentication!(omniauth_data)

        sign_in resource
        redirect_to after_sign_in_path_for(resource), notice: I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)

      else
        # Create a new user.
        build_resource({})
        resource.apply_omniauth(omniauth_data)
        resource.skip_confirmation! if resource.respond_to?('skip_confirmation!') # TODO: Make this configurable?

        if resource.save
          resource.reload
          sign_up(resource_name, resource)
          redirect_to after_sign_up_path_for(resource), notice: I18n.t('devise.omniauth_callbacks.success', kind: provider.human_name)
        else
          # The user couldn't be created. Most probably the omniauth data
          # didn't have all the required information. Like for example Twitter
          # is not sending email addresses. We need to ask the user to provide
          # the missing details.
          session[:omniauth] = omniauth_data.except('extra')
          redirect_to new_user_registration_path, notice: I18n.t('devise.omniauth_callbacks.provide_missing_details')
        end
      end
    end
end
