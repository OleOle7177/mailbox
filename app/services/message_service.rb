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
				# imap.search(['ALL']).each do |message_id|
				message_id = imap.search(['ALL']).first

				msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
				mail = Mail.read_from_string msg

		p '!' * 50
				p mail.parts[0].body.decoded.force_encoding("ISO-8859-1").encode("UTF-8")
				# p mail.parts[1].body

				# p mail.body
				p mail.subject
				p mail.from
				p mail.to
				p mail.attachments

		p '!' * 50



				message = Message.create!(user_id: user_id, from: mail.from, 
																	to: mail.to, body: mail.parts[0].body.decoded.force_encoding("ISO-8859-1").encode("UTF-8"), 
																	date: mail.date, subject: mail.subject)
			
				# mail.attachments.each do |attachment|
				# 	filename = save_attachment attachment
				# 	Document.create!(message: message, attachment_file_name: filename) 
				# end
			# end

		# rescue Net::IMAPAuthenticationError => e
		# 	message_logger.debug e.message
		# 	error = e
		rescue StandardError => e
			p e
			message_logger.debug e.message
		end
		
		error
	end

	private

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
