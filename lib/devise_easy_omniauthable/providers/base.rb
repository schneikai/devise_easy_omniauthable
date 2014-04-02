module DeviseEasyOmniauthable
  module Providers
    # Returns the provider class for the given provider name
    def self.find_by_name(name)
      "DeviseEasyOmniauthable::Providers::#{name.to_s.classify}".constantize
    end

    class Base
      def initialize(omniauth_data)
        @omniauth_data = omniauth_data
        self
      end

      # Returns the provider name as symbol.
      #
      #   DeviseEasyOmniauthable::Providers::GoogleOauth2.identifier
      #   => :google_oauth2
      #
      def self.identifier
        name.split('::').last.underscore.to_sym
      end

      def identifier
        self.class.identifier
      end

      # Returns the humanized provider name.
      #
      #   DeviseEasyOmniauthable::Providers::Facebook.human_name
      #   => 'Facebook'
      #
      def self.human_name
        name.split('::').last.humanize
      end

      def human_name
        self.class.human_name
      end

      # Returns the +info+ part from the omniauth data. That usually contains
      # data such as email, username, first and last name.
      def omniauth_info
        @omniauth_data.info
      end

      private
        # Copy a +value+ to the +attribute+ on +resource+ if the attribute exists
        # on the resource and if it is empty.
        # +attribute+ can be a symbol or a array of symbols. If a array is given
        # then the +value+ is copied to all attributes. This is usefull if you
        # are not exactly sure what the attribute is called on the resource. For
        # example <tt>first_name</tt> vs. <tt>firstname</tt>.
        def copy_attribute(resource, attribute, value)
          Array(attribute).each do |attr|
            resource.send("#{attr}=", value) if resource.respond_to?(attr) && resource.send(attr).blank?
          end
        end

    end
  end
end
