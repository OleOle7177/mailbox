class MessagesController < ApplicationController 

before_action :authenticate_user!

def index 
	if params[:refresh] == 'true'
		service = MessageService.new
		errors = service.refresh_mail_list(current_user.id)
		
		if errors.present?
			flash[:danger] = 'Connection refused'
		else 
			flash[:success] = 'Successfully updated'
		end

	end

	@messages = Message.current_user(current_user.id)
										 .paginate(:page => params[:page], :per_page => 2)

end

def show
end

end
