Spree::Core::Engine.routes.draw do

  get "/wholesaler/states" => "spree/wholesaler_states#index"

  get '/wholesaler/registration' => 'wholesaler#registration', :as => :wholesaler_registration
  put '/wholesaler/registration' => 'wholesaler#update_registration', :as => :update_wholesaler_registration

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
