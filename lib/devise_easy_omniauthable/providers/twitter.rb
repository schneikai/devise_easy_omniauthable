require 'omniauth-twitter'

module DeviseEasyOmniauthable
  module Providers
    class Twitter < DeviseEasyOmniauthable::Providers::Base
      def apply_to(resource)
        # Twitter does not provide email addresses :(

        # omni.info.nickname (e.g. kaischneider)
        # omni.info.name (e.g. Kai Schneider)
        # omni.info.location (e.g. Berlin)
        # omni.info.image (e.g. http://a0.twimg.com/profile_images/3120095484/cb33c7debb71738617c005e666ba5db4_normal.jpeg (can be a empty (just white) image!))
        # omni.info.urls['Twitter'] (e.g. https://twitter.com/kaischneider)
        # omni.info.urls['Website'] (e.g. http://t.co/tjFW27r5iI)

        copy_attribute resource, [:username, :nickname], omniauth_info.nickname
        copy_attribute resource, :name, omniauth_info.name
      end
    end
  end
end
