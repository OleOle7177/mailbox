require 'spec_helper'
require 'net/http'

describe 'Gmail API' do 
	gmail_account = 'mailbox.test004@gmail.com'
	params = { 
		:access_token => "ya29.5QGqF5_DDAd5cJ-9sdDocU-kE5uMegGPgfykl1o56d69omihDA4UjUTw77cs99Y_RrMP" 
	}

	it 'get list of emails' do
		uri = URI("https://www.googleapis.com/gmail/v1/users/#{gmail_account}/messages")
		uri.query = URI.encode_www_form(params)
		
		response = Net::HTTP.get_response(uri)
		json = JSON.parse(response.body)
		
		expect(response.code).to match("200")
    expect(json['messages'].length).to eq(3)
	end

	it 'get specified email' do
		message_id = "14f9b905d77c4517"
		uri_message = URI("https://www.googleapis.com/gmail/v1/users/#{gmail_account}/messages/#{message_id}")
		uri_message.query = URI.encode_www_form(params)
		
		response = Net::HTTP.get_response(uri_message)
		json = JSON.parse(response.body)

		expect(response.code).to match("200")
		expect(json['id']).to eq(message_id)
	end

end
