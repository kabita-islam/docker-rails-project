Rails.application.routes.draw do

  root "home#signin"
  get '/login', to: 'session#login'
  post '/refresh', to: 'session#refresh'

  resources :users
  
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#logout'

  namespace :api do
    namespace :v1 do
      resources :rides
    end
  end

end
