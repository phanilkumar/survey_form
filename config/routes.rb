Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    resources :surveys, only: [:index, :show, :create] do
      resources :survey_responses, only: [:index, :create, :update, :show]
    end
    
    # Additional routes for user-specific responses
    get 'users/:user_identifier/responses', to: 'survey_responses#user_responses', as: :user_responses
  end

  # Defines the root path route ("/")
  root "api/surveys#index"
end
