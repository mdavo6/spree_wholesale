Spree::Core::Engine.routes.draw do

  get '/wholesaler/states' => 'spree/wholesaler_states#index'

  get '/wholesalers/registration' => 'wholesalers#registration', :as => :wholesaler_registration
  put '/wholesalers/registration' => 'wholesalers#update_registration', :as => :update_wholesaler_registration
  get '/wholesale_cart', to: 'orders#wholesale', as: :wholesale_cart

  get 'wholesalers/welcome' => 'wholesalers#welcome', :as => :wholesaler_welcome

  # For line sheets
  get '/line-sheets/*id', to: 'taxons#line_sheet', as: :line_sheets

  resources :wholesalers

  namespace(:admin) do

    resources :wholesalers do
      member do
        get :approve
        get :reject
      end
    end

    resources :orders, except: [:show] do
      member do
        post :currency, defaults: { format: :json }
      end
    end

    resource :wholesale_configurations
  end

end
