Rails.application.routes.draw do
	root 'driver_sessions#new'

  get '/login', to: 'driver_sessions#new'
	post '/login', to: 'driver_sessions#create'
	delete '/driver_sessions', to: 'driver_sessions#destroy'
	delete '/logout', to: 'driver_sessions#destroy'

  get '/dashboard', to: 'schedule_items#index'
end
