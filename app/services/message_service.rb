require 'fileutils'

class MessageService

	# Create or initialize message logger
	def message_logger
    @@message_logger ||= Logger.new("#{Rails.root}/log/mail.log")
  end

		
	# Receive mails from mailbox, determined in set_mailbox_settings, 
	# and save them to db. 
	# Returns an error if connection was refused, nil otherwise.
	# All errors are logged to message.log
	def refresh_mail_list email, access_token, user_id
		error = nil
		
		begin 
			imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
			imap.authenticate('XOAUTH2', email, access_token)
			imap.select('INBOX')

			# Array of all loaded messages for this user
			gmail_ids = Message.current_user(user_id).pluck(:gmail_id)

			if gmail_ids.blank? 
				received_emails = imap.search(['ALL'])
			else
				received_emails = imap.search(['NOT', gmail_ids])
			end

			received_emails.each do |message_id|
				msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
				mail = Mail.read_from_string msg
				save_message(mail, message_id, user_id)
			end

		rescue StandardError => e
			error = e
			message_logger.debug e.message
		end
		
		error
	end

	private

	# Save messages
	def save_message mail, gmail_id, user_id
		
		if mail.parts.size > 0
			body = mail.parts[0].body.decoded.force_encoding("ISO-8859-1").encode("UTF-8")
		else 
			body = nil
		end

		message = Message.create!(user_id: user_id, from: mail.from, 
															to: mail.to, body: body, 
															date: mail.date, subject: mail.subject,
															gmail_id: gmail_id)
	
		mail.attachments.each do |attachment|
			filename = save_attachment attachment
			Document.create!(message: message, attachment_file_name: filename) 
		end

		message
	end

	# Save attachment to storage folder, 
	# name of the attachment is updated with timestamp 
	def save_attachment attachment
		attachment_dir = File.join("#{Rails.root}", 'storage')

		unless File.directory?(attachment_dir)
  		FileUtils.mkdir_p(attachment_dir)
		end

		new_filename = "#{Time.zone.now.to_i}_" + attachment.filename 

    File.open(attachment_dir + '/'+ new_filename, "w+b", 0644) do |f|
    	f.write attachment.body.decoded
  	end

  	new_filename
  end

end
