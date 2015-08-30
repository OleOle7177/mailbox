require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

RSpec.describe "redirects correct on user actions", :type => :feature do

	it "simulates user behaviour on show and index page" do 
		User.destroy_all
		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		20.times {FactoryGirl.create(:message, user_id: user_1.id)}
		20.times {FactoryGirl.create(:message, user_id: user_2.id, subject: "User_2 subject")}
  	
  	expect(user_1.messages.count).to eq(20)
    
    # login
    login_as(user_1, :scope => :user)
    
    # testing user can see only his messages
    visit root_url
		expect(page).not_to have_link('User_2 subject')	
		expect(page).to have_link('Subject of letter 1')	
		
		# testing Russian locale select
		click_link ('Русский')
		expect(page).to have_content('От кого')
		expect(page).to have_content('Тема')
		expect(page).to have_content('Дата')

		# testing English locale select
		click_link ('English')
		expect(page).to have_content('From')
		expect(page).to have_content('Subject')
		expect(page).to have_content('Date')

		# testing redirect to message show
		click_link ('Subject of letter 1')
		expect(page).to have_content('Body of letter 1')
  end
end
