class Document < ActiveRecord::Base
	belongs_to 				:message, inverse_of: :documents
	has_attached_file :attachment, :path => ":rails_root/storage/:basename.:extension",
																 :url =>  ":rails_root/storage/:basename.:extension"

	validates :attachment_file_name, presence: true
end
