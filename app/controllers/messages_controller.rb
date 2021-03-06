class MessagesController < ApplicationController 

	before_action :authenticate_user!

	def index 
		if params[:refresh] == 'true'
			refresh_mails			
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

	private 

	def refresh_mails
		auth = session["devise.google_data"]
		
		# Get new token if token expired
		if Time.now.utc >= current_user.token_expires_at
			begin 
				auth["credentials"]["token"] = current_user.update_token
			rescue StandardError => e
				redirect_to root_path
				reset_session
			end
		end

		service = MessageService.new
		errors = service.refresh_mail_list(auth["info"]["email"], auth["credentials"]["token"], current_user.id)
		
		if errors.present?
			flash[:error] = t 'refresh_mails.failed.'
		else 
			flash[:success] = t 'refresh_mails.successfully_updated.'
		end

		flash.discard  
	end

end
