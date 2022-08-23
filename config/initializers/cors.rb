# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins %r{http://localhost:\d+},
            %r{http://127.0.0.1:\d+},
            %r{http://192.168.\d+.\d{1,3}(:\d+)?},
            'api-real.herokuapp.com',
            'api-real-prod.herokuapp.com'

    resource '*',
             headers: :any,
             methods: %i[get post delete put options head],
             max_age: 20 * 24 * 60 * 60
  end
end
