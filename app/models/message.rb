class Message < ActiveRecord::Base
	has_many :documents, inverse_of: :message

	default_scope { order('date DESC') }

	scope :current_user, lambda{ |user| where(user_id: user)}
end