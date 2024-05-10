Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resources :home, only: :index

  resources :poker_sessions, only: [:show, :new, :create, :edit, :update] do
    post "/toggle_estimates_visibility", to: "poker_sessions#toggle_estimates_visibility"
    post "/delete_estimates", to: "poker_sessions#delete_estimates"

    resources :poker_session_participants, only: [:new, :create] do
      post "/activate_participant", to: "poker_session_participants#activate_participant"
      post "/deactivate_participant", to: "poker_session_participants#deactivate_participant"

      resources :poker_session_participant_estimates, only: :create
    end
  end
end
