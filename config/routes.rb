Rails.application.routes.draw do

  devise_for :users, skip: [:session, :password, :registration, :confirmation], controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
		root to: "messages#index"  

	  devise_for :users, path: '', skip: :omniauth_callbacks, 
	  	controllers: {sessions: "users/sessions", registrations: "users/registrations"}

	  resources :messages, only: [:index, :show] do 
	    get 'download_attachment', on: :collection
	 	end
	end

	get '*path', to: redirect("/#{I18n.default_locale}/%{path}")
	get '', to: redirect("/#{I18n.default_locale}")

end
