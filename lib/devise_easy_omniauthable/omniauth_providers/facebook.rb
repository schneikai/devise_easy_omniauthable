require 'omniauth-facebook'

module DeviseEasyOmniauthable
  module OmniauthProviders
    module Facebook
      def self.human_name
        "Facebook"
      end

      def apply_to(resource)
        # omni.info.nickname (e.g. kaischneider)
        # omni.info.email (e.g. schneikai@gmail.com)
        # omni.info.name (e.g. Kai Schneider)
        # omni.info.first_name (e.g. Kai)
        # omni.info.last_name (e.g. Schneider)
        # omni.info.image (e.g. http://graph.facebook.com/1570798016/picture?type=square, 50x50)
        # omni.info.urls['Facebook'] (e.g. https://www.facebook.com/kaischneider)

        apply resource, :username, :nickname
        apply resource, :email, :email
        apply resource, :name, :name
        apply resource, :first_name, :first_name
        apply resource, :firstname, :first_name
        apply resource, :last_name, :last_name
        apply resource, :lastname, :last_name
      end
    end
  end
end
