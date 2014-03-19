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
        # Returns +true+ if omniauth providers are configured and omniauth can be used.
        # Otherwise +false+.
        def omniauthable?
          try(:omniauth_providers) && omniauth_providers.any?
        end
      end

      # Returns +true+ if omniauth providers are configured and omniauth can be used.
      # Otherwise +false+.
      def omniauthable?
        self.class.omniauthable?
      end

      # Returns +array+ of all configured omniauth providers. Returns empty array
      # if no providers are configured.
      def omniauth_providers
        self.class.try(:omniauth_providers) || []
      end

      # Checks whether a password is needed or not. For validations only.
      # Passwords are always required if it's a new record and no authentications
      # exists, or if the password or confirmation are being set somewhere.
      def password_required?
        puts "password_required EasyOmniauthable"

        # Devise checks:
        # !persisted? || !password.nil? || !password_confirmation.nil?

        # We check:
        (!persisted? && authentications.empty?) || !password.nil? || !password_confirmation.nil?

        # # We need to define when a password is not required and call super
        # # to allow to evaluate overwritten methods.
        # if new_record? && authentications.any? && password.blank? && password_confirmation.blank?
        #   false
        # else
        #   super
        # end
      end

      # Returns +true+ if the user has a password. Otherwise +false+.
      # If a user signed up via omniouth he doesn't have a password and for
      # example in the <tt>registrations#edit</tt> you shouldn't allow to change
      # the current password or ask for the current password on account updates.
      def password?
        encrypted_password.present?
      end



      # We need to overwrite this devise method to allow users who signed up via
      # omniauth and don't have a password to update their accounts.
      def update_with_password(params, *options)
        result = if encrypted_password.blank?
          # Never allow to change the password.
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

        # Assigns omniauth attributes to attributes on the model.
        # For example "model.username = omni.info.nickname".
        DeviseEasyOmniauthable::OmniauthInfo.new(omniauth['provider'], omniauth.info).apply_to(self)
      end
    end
  end
end
