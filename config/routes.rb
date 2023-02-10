Rails.application.routes.draw do
  # Site Home
  root 'site#home'
  get '/home', to: 'site#home'

  # User Pages
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'

  # Info Pages
  get '/help', to: 'info#help'
  get '/about', to: 'info#about'
  get '/contact', to: 'info#contact'

  put 'admin/:id' => 'users#make_admin', :as => "make_admin"

  # Presentation Groups Controller
  # r tget '/add-user-to-group', to "presentation_group#add_user"

  resources :presentations
  resources :users
  resources :feedback_forms
  resources :feedback_assignments, only: %i[index new create destroy]
  post '/feedback_assignments/:id', to: 'feedback_forms#destroy'
  resources :feedback_responses, only: %i[index new create]
end
