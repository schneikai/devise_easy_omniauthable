require 'omniauth-google-oauth2'

module DeviseEasyOmniauthable
  module Providers
    class GoogleOauth2 < DeviseEasyOmniauthable::Providers::Base
      def self.human_name
        "Google"
      end

      def apply_to(resource)
        # omni.info.email (e.g. schneikai@gmail.com)
        # omni.info.name (e.g. Kai Schneider)
        # omni.info.first_name (e.g. Kai)
        # omni.info.last_name (e.g. Schneider)
        # omni.info.image (e.g. https://lh3.googleusercontent.com/-5YMdpgO4vko/AAAAAAAAAAI/AAAAAAAAAD4/LmMMc5heUKI/photo.jpg, original uploaded size)
        # omni.info.urls['Google'] (e.g. https://plus.google.com/114099184588852949310)

        copy_attribute resource, :email, omniauth_info.email
        copy_attribute resource, [:username, :nickname], omniauth_info.first_name || omniauth_info.name
        copy_attribute resource, :name, omniauth_info.name || [omniauth_info.first_name, omniauth_info.last_name].compact.join(' ')
        copy_attribute resource, [:first_name, :firstname], omniauth_info.first_name
        copy_attribute resource, [:last_name, :lastname], omniauth_info.last_name
      end
    end
  end
end
