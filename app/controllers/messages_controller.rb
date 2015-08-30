class MessagesController < ApplicationController 

	before_action :authenticate_user!

	def index 
		if params[:refresh] == 'true'
			service = MessageService.new
			errors = service.refresh_mail_list(current_user.id)
			
			if errors.present?
				flash[:error] = t 'refresh_mails.connection_refused.'
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
