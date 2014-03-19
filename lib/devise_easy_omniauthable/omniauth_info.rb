# Assign return data from omniauth to a given resource (user model for example).
module DeviseEasyOmniauthable
  class OmniauthInfo
    def initialize(provider, info)
      @provider = provider
      @provider_class = DeviseEasyOmniauthable::OmniauthInfo.get_provider(@provider)
      @info = info

      # Load provider specific module.
      extend @provider_class
    end

    # Returns the provider class for the given provider name.
    def self.get_provider(provider)
      "DeviseEasyOmniauthable::OmniauthProviders::#{provider.to_s.classify}".constantize
    end

    # Returns the humanized name of the current provider.
    def provider_human_name
      @provider_class.human_name
    end

    private
      # Copy a value from source to target on the resource if the target exists
      # on the resource and if it is empty.
      def apply(resource, target, source)
        resource.send("#{target}=", @info.send(source)) if resource.respond_to?(target) && resource.send(target).blank?
      end
  end
end
