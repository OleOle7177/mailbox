class Users::SessionsController < Devise::SessionsController
	
	# Redefine to update mailbox settings every time user creates a new session
	def create
	  super 
	  password = sign_in_params[:password]
	  email = sign_in_params[:email]
	  MessageService.set_mailbox_settings(email, password)
	end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

end