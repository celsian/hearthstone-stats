class RegistrationsController < Devise::RegistrationsController

  private

    def sign_up_params
      allow = [:email, :username, :password, :password_confirmation]
      params.require(resource_name).permit(allow)
    end

    def account_update_params
      allow = [:email, :username, :password, :password_confirmation, :current_password]
      params.require(resource_name).permit(allow)
    end
end