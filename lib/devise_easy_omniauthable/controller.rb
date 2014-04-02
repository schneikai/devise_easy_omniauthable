module DeviseEasyOmniauthable
  module Controller
    extend ActiveSupport::Concern

    included do
      helper_method :omniauth_authorize_default_params
      before_filter :clear_omniauth, if: :clear_omniauth?
    end

    # Provide default parameters for omniauth authorization.
    # By default we add the current locale here so that the providers authorization
    # page is displayed in the same language as your App if the provider supports that.
    # You can overwrite this method in your application controller to change the default params.
    def omniauth_authorize_default_params(provider=nil)
      {
        locale: I18n.locale,
        lang: I18n.locale
      }
    end

    private
      # When the user is signing up via omniauth and required information like
      # for example a email address is missing the omniauth data is saved to the
      # session and the user is taken back to the registration where the omniauth
      # data is read back from the session and the user can add the missing details.
      # We need a way that a user can cancel omniauth signup by removing the
      # omniauth session data. We do this when he goes to a page that is not a
      # Devise controller. So that the user can for example go back to the homepage
      # and then back to the registration page to start fresh.
      #
      # TODO: How it is setup right now, this would modify the session on every
      # request that is not a Devise controller. I don't know if this might be
      # a performance problem...

      # Removes omniauth data from the session.
      def clear_omniauth
        session.delete(:omniauth)
      end

      # Returns +true+ if omniauth data should be removed from the session.
      # Otherwise +false+.
      def clear_omniauth?
        !devise_controller?
      end
  end
end
