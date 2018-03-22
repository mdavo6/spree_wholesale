Spree::Core::Engine.routes.draw do

  get '/wholesaler/states' => 'spree/wholesaler_states#index'

  get '/wholesalers/registration' => 'wholesalers#registration', :as => :wholesaler_registration
  put '/wholesalers/registration' => 'wholesalers#update_registration', :as => :update_wholesaler_registration
  get '/wholesale_cart', to: 'orders#wholesale', as: :wholesale_cart

  resources :wholesalers

  namespace(:admin) do

    resources :wholesalers do
      member do
        get :approve
        get :reject
      end
    end

    resource :wholesale_configurations
  end

end
