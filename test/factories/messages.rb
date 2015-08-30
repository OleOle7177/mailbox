FactoryGirl.define do
	factory :message do
		from ["from@test.ru"]
		to ["to@test.ru"]
		date DateTime.now
		sequence(:subject) {|i| "Subject of letter #{i}"}
		sequence(:body) {|i| "Body of letter #{i}"}
	end
end
