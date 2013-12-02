RailsApp::Application.routes.draw do

  root 'click_to_call#index'

  resources :click_to_call, only: [:index, :create, :destroy]
end
