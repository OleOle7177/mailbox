FactoryGirl.define do
	factory :user do
		sequence(:email) {|i| "user_#{i}@test.ru"}
		password "12345678"
	end
end
