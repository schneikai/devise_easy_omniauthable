require 'omniauth-facebook'

module DeviseEasyOmniauthable
  module Providers
    class Facebook < DeviseEasyOmniauthable::Providers::Base
      def apply_to(resource)
        # omni.info.email (e.g. schneikai@gmail.com)
        # omni.info.nickname (e.g. kaischneider)
        # omni.info.name (e.g. Kai Schneider)
        # omni.info.first_name (e.g. Kai)
        # omni.info.last_name (e.g. Schneider)
        # omni.info.image (e.g. http://graph.facebook.com/1570798016/picture?type=square, 50x50)
        # omni.info.urls['Facebook'] (e.g. https://www.facebook.com/kaischneider)

        copy_attribute resource, :email, omniauth_info.email
        copy_attribute resource, [:username, :nickname], omniauth_info.nickname
        copy_attribute resource, :name, omniauth_info.name || [omniauth_info.first_name, omniauth_info.last_name].compact.join(' ')
        copy_attribute resource, [:first_name, :firstname], omniauth_info.first_name
        copy_attribute resource, [:last_name, :lastname], omniauth_info.last_name
      end
    end
  end
end
