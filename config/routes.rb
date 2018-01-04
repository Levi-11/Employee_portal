Rails.application.routes.draw do

  get '/adminlogin',to:'adminsession#new'

  post '/adminlogin',to:'adminsession#create'

  delete '/adminlogout',to:'adminsession#destroy'

  get '/adminhome',to:'admin#home'

  get '/adminemployee',to:'admin#index'

  get '/adminedit',to:'admin#edit'

  patch '/adminedit', to: 'admin#update'

  get '/adminproject',to:'admin#projects'

  get  '/addemployee',  to: 'admin#addemployee'
  
  post '/addemployee',  to: 'admin#create'

  get '/showemployee',to:'admin#show'
  
  post '/showemployee',to:'admin#show'

  get '/home',to:'employees#home'

  get    '/login',   to: 'sessions#new'

  post   '/login',   to: 'sessions#create'

  delete '/logout',  to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'sessions#new'  
  resources :employees 
end
