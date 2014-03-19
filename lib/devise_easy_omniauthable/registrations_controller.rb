# Extensions for the devise registrations controller.
#
# When a user registers via omniauth provider and vital registration details
# such as username or email adress are missing from the omniauth response data
# the user is taken to the registration page where he is asked to provide the
# missing details.

module DeviseEasyOmniauthable
  module RegistrationsController
    extend ActiveSupport::Concern

    included do
      prepend_after_filter :clear_omniauth, only: [ :create ]
      alias_method_chain :build_resource, :omniauth
    end

    protected
      # Removes omniauth data from the session data.
      def clear_omniauth
        session[:omniauth] = nil unless @user.new_record?
      end

      # When the user is taken to the registration page during oauth signup
      # to complete or fix his details we need to copy this details from the
      # auth response to the user model.
      def build_resource_with_omniauth(hash=nil)
        build_resource_without_omniauth hash
        if session[:omniauth]
          @user.apply_omniauth(session[:omniauth])
          @user.valid?
        end
      end
  end
end
