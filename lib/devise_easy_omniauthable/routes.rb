module ActionDispatch::Routing
  class Mapper
    protected
      def devise_easy_omniauthable(mapping, controllers)
        resources :authentications, only: [:index, :destroy],
          path: mapping.path_names[:authentications], controller: controllers[:authentications]
      end
  end
end
