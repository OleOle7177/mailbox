class Message < ActiveRecord::Base
	has_many :documents, inverse_of: :message
	belongs_to :user

	validates :from, :to, :date, presence: true

	default_scope { order('date DESC') }
	scope :current_user, lambda{ |user| where(user_id: user)}
end