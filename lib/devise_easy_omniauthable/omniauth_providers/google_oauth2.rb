require 'omniauth-google-oauth2'

module DeviseEasyOmniauthable
  module OmniauthProviders
    module GoogleOauth2
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

        apply resource, :username, :name
        apply resource, :email, :email
        apply resource, :first_name, :first_name
        apply resource, :firstname, :first_name
        apply resource, :last_name, :last_name
        apply resource, :lastname, :last_name
      end
    end
  end
end
