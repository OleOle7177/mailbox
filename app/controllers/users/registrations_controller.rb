class Users::RegistrationsController < Devise::RegistrationsController
  
  # Redefine sign_up method to update mailbox settings on successfull user sign up
  def sign_up(resource_name, resource)
    email = resource_params[:email]
    password = resource_params[:password]
    MessageService.set_mailbox_settings(email, password)

    sign_in(resource_name, resource)
  end

end