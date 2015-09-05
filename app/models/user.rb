# require 'rest_client'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  devise  :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :messages

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data['email']).first

    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0,20],
        refresh_token: access_token['credentials']['refresh_token'],
        # token_expires_at: Time.now.utc + access_token['credentials']['expires_at'].to_i.seconds
        token_expires_at: Time.now.utc + 3600.seconds
      )
    end
    user
  end

  # Refresh users token
  def update_token

    conn = Faraday.new('https://accounts.google.com') do |conn|
      conn.request  :url_encoded
      conn.response :raise_error
      conn.response :logger unless Rails.env.production?
      conn.adapter  Faraday.default_adapter
    end
    
    response = conn.post('/o/oauth2/token', {
      grant_type:    'refresh_token',
      refresh_token: refresh_token,
      client_id:     GOOGLE_CONFIG['google_key'],
      client_secret: GOOGLE_CONFIG['google_secret']
    })

    body = JSON.parse response.body

    if body['access_token'].present?
      # self.token_expires_at = Time.now.utc + body['expires_in'].to_i.seconds
      self.token_expires_at = Time.now.utc + 3600.seconds
      self.save!
    end

    body['access_token']

  end

end
