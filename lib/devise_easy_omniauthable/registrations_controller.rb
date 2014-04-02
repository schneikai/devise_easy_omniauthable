# Extensions for the Devise registrations controller.

module DeviseEasyOmniauthable
  module RegistrationsController
    extend ActiveSupport::Concern

    included do
      alias_method_chain :build_resource, :omniauth
    end

    protected
      # Initialize the resource with the additional details from omniauth.
      # When the user is signing up via omniauth and required information like
      # for example a email address is missing the omniauth data is saved to the
      # session and the user is taken back to the registration where the omniauth
      # data is read back from the session and the user can add the missing details.
      def build_resource_with_omniauth(hash=nil)
        build_resource_without_omniauth hash
        if omniauth = session[:omniauth]
          @user.apply_omniauth(omniauth)
          @user.valid?
        end
      end
  end
end
