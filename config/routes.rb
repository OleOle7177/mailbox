Rails.application.routes.draw do

  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

	  devise_for :users, controllers: {sessions: "users/sessions", registrations: "users/registrations"}

		root to: "messages#index"  

	  resources :messages, only: [:index, :show] do 
	    get 'download_attachment', on: :collection
	 	end
	end

	get '*path', to: redirect("/#{I18n.default_locale}/%{path}")
	get '', to: redirect("/#{I18n.default_locale}")

end
