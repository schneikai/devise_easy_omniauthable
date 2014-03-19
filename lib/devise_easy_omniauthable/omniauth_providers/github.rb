require 'omniauth-github'

module DeviseEasyOmniauthable
  module OmniauthProviders
    module Github
      def self.human_name
        "Github"
      end

      def apply_to(resource)
        # omni.info.nickname (e.g. schneikai)
        # omni.info.email (e.g. schneikai@gmail.com)
        # omni.info.name (e.g. Kai Schneider)
        # omni.info.image (e.g. https://0.gravatar.com/avatar/f497937e4092355c864f7086fda71f4e?d=https%3A%2F%2Fidenticons.github.com%2F00279de92b1e29d94d807deb48231b36.png, 70x70)
        # omni.info.urls['GitHub'] (e.g. https://github.com/schneikai)

        apply resource, :username, :nickname
        apply resource, :email, :email
        apply resource, :name, :name
      end
    end
  end
end
