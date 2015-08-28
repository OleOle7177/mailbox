class Document < ActiveRecord::Base
	belongs_to 				:message, inverse_of: :documents
	has_attached_file :attachment, :path => File.join("#{Rails.root}", 'attachments')

	validates :attachment_file_name, presence: true
end

# link to download
# http://stackoverflow.com/questions/23065676/create-link-to-for-downloading-a-file-from-paperclip-gem