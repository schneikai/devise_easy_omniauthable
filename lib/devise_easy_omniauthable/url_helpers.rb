module DeviseEasyOmniauthable
  module UrlHelpers
    # Overwrite this Devise method and add default parameters via the
    # <tt>omniauth_authorize_default_params</tt> controller and helper method.
    def omniauth_authorize_path(resource_or_scope, *args)
      options = args.extract_options!
      options = omniauth_authorize_default_params(args.first).merge(options)
      super resource_or_scope, *(args << options)
    end

    [:path, :url].each do |path_or_url|
      [nil].each do |action|
        class_eval <<-URL_HELPERS, __FILE__, __LINE__ + 1
          def #{action}authentications_#{path_or_url}(resource, *args)
            resource = case resource
              when Symbol, String
                resource
              when Class
                resource.name.underscore
              else
                resource.class.name.underscore
            end

            send("#{action}\#{resource}_authentications_#{path_or_url}", *args)
          end

          # Singular routes for destroy action.
          def #{action}authentication_#{path_or_url}(resource, *args)
            resource = case resource
              when Symbol, String
                resource
              when Class
                resource.name.underscore
              else
                resource.class.name.underscore
            end

            send("#{action}\#{resource}_authentication_#{path_or_url}", *args)
          end
        URL_HELPERS
      end
    end
  end
end
