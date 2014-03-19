module DeviseEasyOmniauthable
  class Authentication < ActiveRecord::Base
    self.table_name = "devise_easy_omniauthable_authentications"
    belongs_to :authenticatable, polymorphic: true

    validates :authenticatable, presence: true

    # Returns the humanized name for the current provider
    def human_provider_name
      DeviseEasyOmniauthable::OmniauthInfo.get_provider(self.provider).human_name
    rescue NameError
      self.provider
    end
  end
end
