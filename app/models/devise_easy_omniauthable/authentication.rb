module DeviseEasyOmniauthable
  class Authentication < ActiveRecord::Base
    self.table_name = "devise_easy_omniauthable_authentications"
    belongs_to :authenticatable, polymorphic: true
    validates :authenticatable, presence: true
  end
end
