require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

RSpec.describe "user login and create on sign up", :type => :feature do

	before(:each) do 
		User.destroy_all
	end

	it "not authorized user redirected to sign in path" do
		visit root_path
		expect(current_path).to eq(new_user_session_path)
	end

	it "sign up creates a new user" do
		visit new_user_registration_path
		expect(current_path).to eq(new_user_registration_path)

		fill_in 'user_email', with: 'test@test.ru'
		fill_in 'user_password', with: '123123123'
		fill_in 'user_password_confirmation', with: '123123123'

		expect { click_button 'Sign up' }.to change{User.count}.by(1)

		expect(current_path).to eq(root_path)
	end

	it "successfull login makes messages_path accessible" do

    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)

    visit messages_path
    expect(current_path).to eq(messages_path)
  end

end
