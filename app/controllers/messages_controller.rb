class MessagesController < ApplicationController 

	before_action :authenticate_user!

	def index 
		if params[:refresh] == 'true'
			
			auth = session["devise.google_data"]
			
			# Get new token if token expired
			if Time.now.utc >= current_user.token_expires_at
				auth["credentials"]["token"] = current_user.update_token
			end

			email = auth["info"]["email"]
			access_token = auth["credentials"]["token"]

			service = MessageService.new
			errors = service.refresh_mail_list(email, access_token, current_user.id)
			
			if errors.present?
				flash[:error] = t 'refresh_mails.failed.'
			else 
				flash[:success] = t 'refresh_mails.successfully_updated.'
			end

			flash.discard  
		end

		@messages = Message.current_user(current_user.id)
											 .paginate(:page => params[:page], :per_page => 50)

	end

	def show
		@message = Message.find(params[:id])
	end

	def download_attachment
		send_file params[:path]
	end

end
