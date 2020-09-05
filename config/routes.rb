Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      # User registration, login and email verification routes
      resources :users, only: [:create]
      post "/users/login", to: "users#login"
      get "/users/verify_email/:token", to: "users#verify_email"

      # Properties routes
      resources :properties
    end
  end
end
