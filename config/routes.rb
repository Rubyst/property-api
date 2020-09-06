Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      root to: "users#welcome"
      # User registration, login and email verification routes
      resources :users, only: [:create]
      post "/users/login", to: "users#login"
      get "/users/verify_email/:token", to: "users#verify_email"

      # Properties routes
      resources :properties
      get "/user_properties", to: "properties#user_listings"
      get "/properties/search/:category/:location", to: "properties#search"

      #bookings routes
      post "/bookings/:property_id", to: "bookings#create"
      get "/bookings/:property_id", to: "bookings#index"
      put "/bookings/:id/approve", to: "bookings#approve"
      put "/bookings/:id/decline", to: "bookings#decline"
    end
  end
end
