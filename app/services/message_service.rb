require 'fileutils'

class MessageService

	# Create or initialize message logger
	def self.message_logger
    @@message_logger ||= Logger.new("#{Rails.root}/log/message.log")
  end

		
	# Set up mailbox
	def self.set_mailbox_settings
		Mail.defaults do
  		retriever_method :pop3, :address    => "pop.gmail.com",
		                          :port       => 995,
		                          :user_name  => 'oleole7177',
		                          :password   => 'olegoleg89',
		                          :enable_ssl => true
			end
	end

	# Receive mails from mailbox, determined in set_mailbox_settings, 
	# and save them to db. 
	# Returns an error if connection was refused, nil otherwise.
	# All errors are logged to message.log
	def self.refresh_mail_list 
		error = nil
		
		begin 
			mails = Mail.all

			mails.each do |mail|
				message = Message.create!(from: mail.from, to: mail.to, body: mail.body, date: mail.date)
			
				mail.attachments.each do |attachment|
					save_attachment attachment
				end
			end

		rescue Net::POPAuthenticationError => e
			message_logger.debug e.message
			error = e
		rescue StandardError => e
			message_logger.debug e.message
		end
		
		error
	end

	# Save attachment to attachments folder, 
	# name of the attachment is updated with timestamp 
	def self.save_attachment attachment
		attachment_dir = File.join("#{Rails.root}", 'attachments')

		unless File.directory?(attachment_dir)
  		FileUtils.mkdir_p(attachment_dir)
		end

		new_filename = "#{Time.zone.now.to_i}_" + attachment.filename 

    File.open(attachment_dir + '/'+ new_filename, "w+b", 0644) do |f|
    	f.write attachment.body.decoded
  	end

  	
  end

end
