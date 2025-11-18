Rails.application.routes.draw do

  # get "up" => "rails/health#show", as: :rails_health_check

  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "home#signin"
  get '/login', to: 'session#login'
  resources :users
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#logout'

  namespace :api do
    namespace :v1 do
      resources :rides
    end
  end

end
