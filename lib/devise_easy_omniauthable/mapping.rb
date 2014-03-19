module DeviseEasyOmniauthable
  module Mapping
    def self.included(base)
      base.alias_method_chain :default_controllers, :easy_omniauthable
    end

    private
      def default_controllers_with_easy_omniauthable(options)
        if omniauthable?
          options[:controllers] ||= {}
          options[:controllers][:omniauth_callbacks] ||= "devise_easy_omniauthable/omniauth_callbacks"
        end
        default_controllers_without_easy_omniauthable(options)
      end
  end
end
