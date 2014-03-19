require 'omniauth-twitter'

module DeviseEasyOmniauthable
  module OmniauthProviders
    module Twitter
      def self.human_name
        "Twitter"
      end

      def apply_to(resource)
        # omni.info.nickname (e.g. kaischneider)
        # omni.info.name (e.g. Kai Schneider)
        # omni.info.location (e.g. Berlin)
        # omni.info.image (e.g. http://a0.twimg.com/profile_images/3120095484/cb33c7debb71738617c005e666ba5db4_normal.jpeg (can be a empty (just white) image!))
        # omni.info.urls['Twitter'] (e.g. https://twitter.com/kaischneider)
        # omni.info.urls['Website'] (e.g. http://t.co/tjFW27r5iI)

        apply resource, :username, :nickname
        apply resource, :name, :name
      end
    end
  end
end
