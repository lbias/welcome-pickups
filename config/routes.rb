Rails.application.routes.draw do
	root 'home#index'

  get '/driver_sessions/new', to: 'driver_sessions#new'
  get '/login', to: 'driver_sessions#new'
	post '/driver_sessions', to: 'driver_sessions#create'
	post '/login', to: 'driver_sessions#create'
	delete '/driver_sessions', to: 'driver_sessions#destroy'
	delete '/logout', to: 'driver_sessions#destroy'

  get '/dashboard', to: 'schedule_items#index'

	get 'home/index'
end
