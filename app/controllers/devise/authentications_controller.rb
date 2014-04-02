# Allow users to manage 3rd party authentifications.

class Devise::AuthenticationsController < DeviseController
  prepend_before_filter :authenticate_scope!

  # GET /resource/authentications
  def index
    @authentications = self.resource.authentications
  end

  # DELETE /resource/authentications/id
  def destroy
    authentication = self.resource.authentications.find(params[:id])
    authentication.destroy
    set_flash_message :notice, :authentication_destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_destroy_path_for(resource_name) }
  end

  protected
    # Authenticates the current scope and gets the current resource from the session.
    def authenticate_scope!
      send(:"authenticate_#{resource_name}!", :force => true)
      self.resource = send(:"current_#{resource_name}")
    end

    # The default url to be used after destroying a authentication.
    # You need to overwrite this method in your own AuthenticationsController.
    def after_destroy_path_for(resource)
      signed_in_root_path(resource)
    end

    def load_resource
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    end
end

