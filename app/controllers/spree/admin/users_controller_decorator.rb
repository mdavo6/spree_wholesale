module Spree
    module Admin
      module UsersControllerDecorator

        def addresses
            @addresses = @user.addresses
        end
  
      end
    end
  end
  
  ::Spree::Admin::UsersController.prepend(Spree::Admin::UsersControllerDecorator)
  