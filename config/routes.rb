Rails.application.routes.draw do
  resources :leave_events
  resources :leave_peroids
  root to: 'leave_events#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  devise_for :users, :controllers => {:sessions => 'sessions',:registrations => 'registrations'}
end
