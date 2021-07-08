module Spree
  module UserRegistrationsControllerDecorator

    def self.prepended(base)
      base.include Spree::WholesaleHelper
    end

    protected

    private

    def redirect_to_checkout_or_account_path(resource)
      resource_path = after_sign_up_path_for(resource)

      if current_store.code.include?("wholesale")
        respond_with resource, location: new_wholesaler_path
      elsif resource_path == spree.checkout_state_path(:address)
        respond_with resource, location: spree.checkout_state_path(:address)
      else
        respond_with resource, location: spree.account_path
      end
    end

  end
end

::Spree::UserRegistrationsController.prepend(Spree::UserRegistrationsControllerDecorator)
