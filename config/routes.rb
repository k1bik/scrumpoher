Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resources :home, only: :index

  resources :poker_sessions, only: [:show, :new, :create] do
    post '/toggle_estimates_visibility', to: 'poker_sessions#toggle_estimates_visibility'
    post '/delete_estimates', to: 'poker_sessions#delete_estimates'

    resources :poker_session_participants, only: [:new, :create] do
      post '/remove_disabled', to: 'poker_session_participants#remove_disabled'
      post '/add_disabled', to: 'poker_session_participants#add_disabled'
      resources :poker_session_participant_estimates, only: :create
    end
  end
end
