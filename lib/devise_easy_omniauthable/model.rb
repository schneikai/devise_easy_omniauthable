module Devise
  module Models
    module EasyOmniauthable
      extend ActiveSupport::Concern

      included do
        # TODO: Building authentications on a new record and saving the record
        # alsways brought "Authentications is invalid" error and save was cancled.
        # This is probably because the new record doesn't have a id when validations
        # are running but it seems like Rails should handle this... Anyway, added
        # "validate: false" here for the moment.
        has_many :authentications, as: :authenticatable, dependent: :destroy, class_name: "DeviseEasyOmniauthable::Authentication", validate: false
      end

      module ClassMethods
        # Finds a user by a omniauth provider and uid. Returns +nil+ if nothing
        # was found.
        def find_for_omniauth(provider, uid)
          DeviseEasyOmniauthable::Authentication.find_by_provider_and_uid(provider, uid).try(:authenticatable)
        end

        # Finds the first user with the given email address for omniauthentication.
        # Returns +nil+ if no user was found.
        def find_for_omniauth_by_email(email)
          self.find_by_email(email)
        end

        # Returns +true+ if omniauth providers are configured and omniauth can
        # be used. Otherwise +false+.
        def omniauthable?
          omniauth_providers.any?
        end

        # Returns +array+ of all configured omniauth providers. Returns empty
        # +array+ if no providers are configured. The original Devise methods
        # returns a array of symbols. If you want to return the provider classes
        # set <tt>classes = true</tt>.
        def omniauth_providers(classes=false)
          if classes
            omniauth_providers.map { |p| DeviseEasyOmniauthable::Providers.find_by_name(p) }
          else
            defined?(super) ? (super() || []) : []
          end
        end
      end

      # Returns +true+ if omniauth providers are configured and omniauth can be used.
      # Otherwise +false+.
      def omniauthable?
        self.class.omniauthable?
      end

      # Returns +array+ of all configured omniauth providers. Returns empty
      # +array+ if no providers are configured. The original Devise methods
      # returns a array of symbols. If you want to return the provider classes
      # set <tt>classes = true</tt>.
      def omniauth_providers(classes=false)
        self.class.omniauth_providers(classes)
      end

      # Devise brings a private method <tt>password_required?</tt> that it uses
      # in validations to check password requirements.
      # We need to change that a little so that if authentications are present
      # we don't require a password because the authentication is the password
      # basically. We also make this method public so we can use it in views
      # to hide the password fields in forms when authentications are present.
      #
      # Remember: When Devise is updating the model it first checks for
      # <tt>params[:password].blank?</tt> and removes the password if it is blank
      # only that after it checks if the model is valid. Thats why they can check
      # for <tt>password.nil?</tt> instead of <tt>password.blank?</tt>.
      def password_required?
        # Just as a reference: Devise checks the following:
        # !persisted? || !password.nil? || !password_confirmation.nil?
        (!persisted? && authentications.empty?) || !password.nil? || !password_confirmation.nil?
      end

      # Returns +true+ if the user has a password. Otherwise +false+.
      # If a user signed up via omniouth he doesn't have a password and for
      # example in the <tt>registrations#edit</tt> you shouldn't allow to change
      # the current password or ask for the current password on account updates.
      def password?
        encrypted_password.present?
      end

      # Users with authentications don't have a password. The authentication is
      # their password. We overwrite this Devise method to make sure they can't
      # set a password.
      # Remember: Devise <tt>update_with_password</tt> means update attributes
      # and password not update model attributes by specifying the current password...
      def update_with_password(params, *options)
        result = unless password?
          params.delete(:password)
          params.delete(:password_confirmation)
          params.delete(:current_password)

          update_attributes(params, *options)
        else
          super
        end

        clean_up_passwords
        result
      end

      def create_or_update_authentication!(omniauth)
        authentication = authentications.find_or_initialize_by(omniauth.slice('provider', 'uid').to_hash)
        authentication.update_attributes!(
          token: omniauth['credentials'].token,
          token_secret: omniauth['credentials'].secret)
      end

      def apply_omniauth(omniauth)
        # Build a Authentification. This gets saved with the model automatically.
        authentications.build(
          provider: omniauth['provider'],
          uid: omniauth['uid'],
          token: omniauth['credentials'].token,
          token_secret: omniauth['credentials'].secret)

        # Copy omniauth data to attributes on the model.
        DeviseEasyOmniauthable::Providers.find_by_name(omniauth['provider']).new(omniauth).apply_to(self)
      end
    end
  end
end
