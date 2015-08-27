class Document < ActiveRecord::Base
	belongs_to 				:message
	has_attached_file :attachment

	validates :attachment_file_name, presence: true
end