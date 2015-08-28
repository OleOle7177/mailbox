Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: "users/sessions", registrations: "users/registrations"}

	root to: "messages#index"  
  resources :messages, only: [:index, :show]
 
end
